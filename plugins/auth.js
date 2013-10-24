(function() {
  var User, check, config, convertHash, crypto, everyauth, exports, log, models, sanitize, validator;

  config = require("../config");

  everyauth = require("everyauth");

  crypto = require("crypto");

  validator = require("validator");

  models = require("../models");

  log = console.log;

  sanitize = validator.sanitize;

  check = validator.check;

  User = models.User;

  convertHash = function(input) {
    var shasum;
    shasum = crypto.createHash("sha1");
    shasum.update(input);
    return shasum.digest("hex");
  };

  exports = module.exports = function(app) {
    var auth;
    everyauth.facebook.entryPath("/auth/facebook").appId(config.oauth.facebook.appId).appSecret(config.oauth.facebook.appSecret).handleAuthCallbackError(function(request, response) {
      return log("error");
    }).findOrCreateUser(function(session, accessToken, accessTokenExtra, fbUserMetadata) {
      var promise;
      promise = this.Promise(null);
      User.getUserByLogin(fbUserMetadata.id, function(error, user) {
        if (error) {
          return promise.fulfill([error]);
        }
        if (user) {
          return promise.fulfill(user);
        } else {
          return User.insert({
            name: fbUserMetadata.username,
            login: fbUserMetadata.id,
            password: "facebook"
          }, function(error, user) {
            return promise.fulfill(user);
          });
        }
      });
      return promise;
    }).redirectPath("/");
    auth = everyauth.password.loginWith("login");
    everyauth.everymodule.userPkey("_id");
    everyauth.everymodule.findUserById(function(id, callback) {
      return User.findById(id, callback);
    });
    everyauth.everymodule.logoutPath("/logout");
    everyauth.everymodule.logoutRedirectPath("/");
    auth.registerView("auth/register");
    auth.getRegisterPath("/register");
    auth.postRegisterPath("/register");
    auth.extractExtraRegistrationParams(function(request) {
      return {
        passwordConfirm: request.param("password-confirm"),
        email: request.param("email")
      };
    });
    auth.validateRegistration(function(userAttribute, errors) {
      var email, login, name, password, passwordConfirm, promise;
      promise = this.Promise(null);
      log(userAttribute);
      name = sanitize(userAttribute.login).xss();
      login = name.toLowerCase();
      password = sanitize(userAttribute.password).trim();
      password = sanitize(password).xss();
      passwordConfirm = sanitize(userAttribute.passwordConfirm).trim();
      passwordConfirm = sanitize(passwordConfirm).xss();
      email = sanitize(userAttribute.email.toLowerCase()).xss();
      if (name === "" && password === "" && passwordConfirm === "") {
        return [
          {
            error: "오류",
            login: login
          }
        ];
      }
      if (name.length < 5) {
        return [
          {
            error: "오류",
            login: login
          }
        ];
      }
      try {
        check(name, "0-9, a-z, A-Z").isAlphanumeric();
      } catch (e) {
        return [
          {
            error: e.message,
            name: name
          }
        ];
      }
      try {
        check(email, "이메일 형식이 아닙니다.").isEmail();
      } catch (e) {
        return [
          {
            error: e.message,
            email: email
          }
        ];
      }
      if (!userAttribute.passwordConfirm) {
        return [
          {
            error: "not match"
          }
        ];
      }
      User.findOne({
        $or: [
          {
            login: login
          }, {
            email: email
          }
        ]
      }, function(error, user) {
        errors = [];
        if (error) {
          errors.push({
            error: "데이터베이스 오류 발생"
          });
        }
        if (user) {
          errors.push({
            error: "같은 이름의 사용자가 존재합니다."
          });
        }
        if (errors.length) {
          return promise.fulfill(errors);
        } else {
          return promise.fulfill({});
        }
      });
      return promise;
    });
    auth.registerUser(function(userAttribute) {
      var promise, user;
      promise = this.Promise(null);
      user = new User({
        name: userAttribute.name,
        login: userAttribute.login.toLowerCase(),
        password: convertHash(userAttribute.password)
      });
      user.save(function(error, user) {
        if (error) {
          return promise.fulfill(["데이터베이스 오류가 발생했습니다."]);
        } else {
          return promise.fulfill(user);
        }
      });
      return promise;
    });
    auth.registerSuccessRedirect("/");
    auth.loginView("auth/login");
    auth.getLoginPath("/login");
    auth.postLoginPath("/login");
    auth.authenticate(function(login, password) {
      var errors, promise;
      errors = [];
      promise = this.Promise();
      User.getUserByLogin(login.toLowerCase(), function(error, user) {
        if (error) {
          errors.push("데이터베이스 오류가 발생했습니다.");
        }
        if (!user) {
          errors.push("존재하지 않는 사용자 입니다.");
        }
        if (user && user.password !== convertHash(password)) {
          errors.push("비밀번호가 일치하지 않습니다.");
        }
        if (errors.length) {
          return promise.fulfill(errors);
        }
        return promise.fulfill(user);
      });
      return promise;
    });
    return auth.loginSuccessRedirect("/");
  };

}).call(this);
