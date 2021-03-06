<!DOCTYPE html>
<html>

<head>
    <script src="../../jquery.min.js"></script>
    <link href="../../bootstrap.min.css" rel="stylesheet">
    <script src="../../bootstrap.min.js"></script>
    <link href="../../style.css" rel="stylesheet">
    <script src="../../md5.js"></script>
    <script>
        function formatMoney(num) {
            num = num.toString().replace(/\$|\,/g, '');
            if (isNaN(num))
                num = "0";
            sign = (num == (num = Math.abs(num)));
            num = Math.floor(num * 100 + 0.50000000001);
            cents = num % 100;
            num = Math.floor(num / 100).toString();
            if (cents < 10)
                cents = "0" + cents;
            for (var i = 0; i < Math.floor((num.length - (1 + i)) / 3); i++)
                num = num.substring(0, num.length - (4 * i + 3)) + ',' +
                        num.substring(num.length - (4 * i + 3));
            return (((sign) ? '' : '-') + num + '.' + cents);
        }

        function checkEmpty(id, name) {
            var value = $("#" + id).val();
            if (value.length == 0) {

                $("#" + id)[0].focus();
                return false;
            }
            return true;
        }


        $(function () {


            $("a.productDetailTopReviewLink").click(function () {
                $("div.productReviewDiv").show();
                $("div.productDetailDiv").hide();
            });
            $("a.productReviewTopPartSelectedLink").click(function () {
                $("div.productReviewDiv").hide();
                $("div.productDetailDiv").show();
            });

            $("span.leaveMessageTextareaSpan").hide();
            $("img.leaveMessageImg").click(function () {

                $(this).hide();
                $("span.leaveMessageTextareaSpan").show();
                $("div.orderItemSumDiv").css("height", "100px");
            });

            $("#userName").blur(function () {
                var phone = $("#userName").val();
                if (!(/^1[34578]\d{9}$/.test(phone))) {
                    $("span.errorMessage").html("请输入正确的手机号");
                    $("div.registerErrorMessageDiv").css("visibility", "visible");
                    return false;
                } else {
                    $("span.errorMessage").html("");
                    $("div.registerErrorMessageDiv").css("visibility", "");
                    $.ajax({
                        url: "/check/user",
                        type: "POST",
                        data: {"userName": $("#userName").val()},
                        dataType: "json",
                        success: function (result) {
                            if (!result) {
                                $("span.errorMessage").html("该手机号已注册");
                                $("div.registerErrorMessageDiv").css("visibility", "visible");
                            }
                        }
                    });
                }
            });

            $("#password").blur(function () {
                var password = $("#password").val();
                if (!CheckPassWord(password)) {
                    $("span.errorMessage").html("密码必须包含数字和字母");
                    $("div.registerErrorMessageDiv").css("visibility", "visible");
                    return false;
                } else {
                    $("span.errorMessage").html("");
                    $("div.registerErrorMessageDiv").css("visibility", "");
                }
            });

            $("#repeatpassword").blur(function () {
                var repeatpassword = $("#repeatpassword").val();
                var password = $("#password").val();
                if (repeatpassword !== password) {
                    $("span.errorMessage").html("两次密码必须一致");
                    $("div.registerErrorMessageDiv").css("visibility", "visible");
                    return false;
                } else {
                    $("span.errorMessage").html("");
                    $("div.registerErrorMessageDiv").css("visibility", "");
                }
            });

            function CheckPassWord(password) {//密码必须包含数字和字母
                var str = password;
                if (str == null || str.length < 8) {
                    return false;
                }
                var reg = new RegExp(/^(?![^a-zA-Z]+$)(?!\D+$)/);
                if (reg.test(str))
                    return true;
            };
        });
    </script>
</head>
<body>
<nav class="top ">
    <div class="top_middle">
        <a href="/">
            车库首页
        </a>
        <span>喵，欢迎来到Allen的车库</span>
        <a href="login">请登录</a>
        <a href="register">免费注册</a>
    </div>
</nav>

<title>注册</title>

<script>
    $(function () {

        $("#sub").click(function () {
            if (0 == $("#userName").val().length) {
                $("span.errorMessage").html("请输入昵称");
                $("div.registerErrorMessageDiv").css("visibility", "visible");
                return false;
            }
            if (0 == $("#userName").val().length) {
                $("span.errorMessage").html("请输入手机号");
                $("div.registerErrorMessageDiv").css("visibility", "visible");
                return false;
            }
            if (0 == $("#password").val().length) {
                $("span.errorMessage").html("请输入密码");
                $("div.registerErrorMessageDiv").css("visibility", "visible");
                return false;
            }
            if (0 == $("#repeatpassword").val().length) {
                $("span.errorMessage").html("请输入重复密码");
                $("div.registerErrorMessageDiv").css("visibility", "visible");
                return false;
            }
            if ($("#password").val() != $("#repeatpassword").val()) {
                $("span.errorMessage").html("重复密码不一致");
                $("div.registerErrorMessageDiv").css("visibility", "visible");
                return false;
            }
            if (0 == $("#verification").val().length) {
                $("span.errorMessage").html("请输入验证码");
                $("div.registerErrorMessageDiv").css("visibility", "visible");
                return false;
            }

            var pwd = $("#password").val();

            var B = {
                "nickName": $("#nickName").val(),
                "userName": $("#userName").val(),
                "password": $.md5(pwd),
                "vrifyCode": $("#verification").val()
            };

            $.ajax({
                url: "/doregister",
                type: "POST",
                data: B,
                dataType: "json",
                success: function (result) {
                    if (result) {
                        window.location.href = "/"
                    } else {
                        $("span.errorMessage").html("注册失败，请联系管理员");
                        $("div.registerErrorMessageDiv").css("visibility", "visible");
                    }
                },
                error: function (result) {
                    $("span.errorMessage").html("验证码错误");
                    $("div.registerErrorMessageDiv").css("visibility", "visible");
                }
            });

            return true;
        });
    })
</script>


<div>

    <div id="loginDiv" style="position: relative">

        <img id="loginBackgroundImg" class="loginBackgroundImg" src="../../bg.jpg">

        <div>
            <div id="loginSmallDiv" class="loginSmallDiv2">
                <div class="registerErrorMessageDiv">
                    <div class="alert alert-danger" role="alert">
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close"></button>
                        <span class="errorMessage"></span>
                    </div>
                </div>
                <table class="registerTable" align="center">
                    <tr>
                        <td class="registerTableLeftTD">昵称</td>
                        <td class="registerTableRightTD"><input id="nickName" name="nickName"
                                                                placeholder="昵称一旦设置成功，无法修改"></td>
                    </tr>
                    <tr>
                        <td class="registerTableLeftTD">手机号</td>
                        <td class="registerTableRightTD"><input id="userName" name="userName"
                                                                placeholder="手机号一旦设置成功，无法修改"></td>
                    </tr>
                    <tr>
                        <td class="registerTableLeftTD">登陆密码</td>
                        <td class="registerTableRightTD"><input id="password" name="password" type="password"
                                                                placeholder="设置你的登陆密码"></td>
                    </tr>
                    <tr>
                        <td class="registerTableLeftTD">密码确认</td>
                        <td class="registerTableRightTD"><input id="repeatpassword" type="password"
                                                                placeholder="请再次输入你的密码"></td>
                    </tr>
                    <tr>
                        <td class="registerTableLeftTD"><img alt="验证码"
                                                             onclick="this.src='/defaultKaptcha?d='+new Date()*1"
                                                             src="/defaultKaptcha" style="width: 80px"></td>
                        <td class="registerTableRightTD"><input id="verification" type="verification"
                                                                placeholder="请输入验证码"></td>
                    </tr>

                    <tr>
                        <td colspan="2">
                            <button></button>
                            <button></button>
                            <button id="sub" style="width: 170px;height: 36px;border-radius: 2px;color: white;background-color: #C40000;border-width: 0px;">提 交</button>
                        </td>
                    </tr>
                </table>
            </div>
        </div>

        <script>
            function submit() {
                var phone = $("#userName").val();
                var pwd = $("#password").val();
                var password = $.md5(pwd);
                var loginUrl;
                if (!(/^1[34578]\d{9}$/.test(phone)) || 8 > pwd.length || pwd.length > 16) {
                    $("span.errorMessage").html("请输入账号密码");
                    $("div.loginErrorMessageDiv").show();
                    return false;
                } else {
                    var redirctUri = getUrlParam("redirect");
                    if (0 === redirctUri.length) {
                        locationHref = "/";
                    } else {
                        locationHref = redirctUri;
                    }
                    $.ajax({
                        url: "/dologin",
                        type: "POST",
                        data: {"userName": phone, "password": password},
                        dataType: "json",
                        success: function (result) {
                            if (result) {
                                window.location.href = locationHref
                            } else {
                                $("span.errorMessage").html("帐号或密码错误");
                                $("div.loginErrorMessageDiv").show();
                            }
                        }
                    });
                }
            }

            function getUrlParam(name) {
                var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
                var r = window.location.search.substr(1).match(reg);  //匹配目标参数
                if (r !== null) return unescape(r[2]);
                return ""; //返回参数值
            }
        </script>

    </div>
</div>


<div class="modal " id="loginModal" tabindex="-1" role="dialog">
    <div class="modal-dialog loginDivInProductPageModalDiv">
        <div class="modal-content">
            <div class="loginDivInProductPage">
                <div class="loginErrorMessageDiv">
                    <div class="alert alert-danger">
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close"></button>
                        <span class="errorMessage"></span>
                    </div>
                </div>

                <div class="login_acount_text">账户登录</div>
                <div class="loginInput ">
							<span class="loginInputIcon ">
								<span class=" glyphicon glyphicon-user"></span>
							</span>
                    <input id="name" name="name" placeholder="手机/会员名/邮箱" type="text">
                </div>

                <div class="loginInput ">
							<span class="loginInputIcon ">
								<span class=" glyphicon glyphicon-lock"></span>
							</span>
                    <input id="password" name="password" type="password" placeholder="密码" type="text">
                </div>
                <span class="text-danger">不要输入真实的考拉账号密码</span><br><br>
                <div>
                    <a href="">忘记登录密码</a>
                    <a href="register" class="pull-right">免费注册</a>
                </div>
                <div style="margin-top:20px">
                    <button class="btn btn-block redButton loginSubmitButton" type="submit">登录</button>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal" id="deleteConfirmModal" tabindex="-1" role="dialog">
    <div class="modal-dialog deleteConfirmModalDiv">
        <div class="modal-content">
            <div class="modal-header">
                <button data-dismiss="modal" class="close" type="button"><span aria-hidden="true">×</span><span
                        class="sr-only">Close</span></button>
                <h4 class="modal-title">确认删除？</h4>
            </div>
            <div class="modal-footer">
                <button data-dismiss="modal" class="btn btn-default" type="button">关闭</button>
                <button class="btn btn-primary deleteConfirmButton" id="submit" type="button">确认</button>
            </div>
        </div>
    </div>
</div>
</div>

<div id="footer" class="footer" style="display: block;">
    <div class="horizontal_line">
    </div>

    <div style="clear:both"></div>
    <div id="copyright" class="copyright">
        <div class="coptyrightMiddle">
            <div class="white_link">
                <a href="/brand/nowhere" style="padding-left:0px">关于车库</a>
                <a href="/brand/nowhere"> 帮助中心</a>
                <a href="/brand/nowhere">开放平台</a>
                <a href="/brand/nowhere"> 诚聘英才</a>
                <a href="/brand/nowhere">联系我们</a>
                <a href="/brand/nowhere">网站合作</a>
                <a href="/brand/nowhere">法律声明</a>
                <a href="/brand/nowhere">知识产权</a>
                <a href="/brand/nowhere"> 廉正举报 </a>
            </div>
            <div class="white_link">
            </div>

            <div class="license">
                <span>增值电信业务经营许可证： 浙B2-20110446</span>
                <span>网络文化经营许可证：浙网文[2015]0295-065号</span>
                <span>互联网医疗保健信息服务 审核同意书 浙卫网审【2014】6号 </span>
                <span>互联网药品信息服务资质证书编号：浙-（经营性）-2012-0005</span>
                <div class="copyRightYear">&copy; 2003-2016 KAOLA.COM 版权所有</div>
                <div>
                    <img src="/copyRight1.jpg">
                    <img src="/copyRight2.jpg">
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
