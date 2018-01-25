package com.redhat.admin.controller;

import com.redhat.admin.bean.User;
import com.redhat.admin.service.UserService;
import com.redhat.admin.util.Coder;
import com.redhat.admin.util.Consts;
import com.redhat.admin.util.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Controller
@RequestMapping("/")
public class UserController {

    @Autowired
    private UserService userService;

    // 验证码 分开验证
    @RequestMapping("validate")
    @ResponseBody
    public boolean validate(HttpServletRequest req, HttpServletResponse resp) {
        String captcha = req.getParameter("captcha");
        Log.info(captcha); // log

        if (captcha != null) {
            String randStr = (String) req.getSession().getAttribute("randStr");
            // 验证成功
            if (randStr != null && randStr.equals(captcha)) {
                return true;
            }
        }
        // 验证失败
        return false;
    }

    // 账号密码 分开验证
    @RequestMapping("login")
    @ResponseBody
    public boolean login(HttpServletRequest req, HttpServletResponse resp) {
        String account = req.getParameter("account");
        String password = req.getParameter("password");
        Log.info(account + " " + password); // log

        if (account != null && password != null) {
            User user = userService.findUser(account);
            password = Coder.md5(password + Consts.SALT); // add salt
            // 登录成功
            if (user != null && password.equals(user.getPassword())) {
                // 更新Session
                req.getSession().setAttribute("user", user);
                return true;
            }
        }
        // 登录失败
        return false;
    }

    // 注销
    @RequestMapping("logout")
    public void logout(HttpServletRequest req, HttpServletResponse resp) {
        Log.info(""); // log

        req.getSession().removeAttribute("user");
        // 跳转根目录
        String baseUrl = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + req.getContextPath();
        try {
            resp.sendRedirect(baseUrl);
        } catch (IOException e) {
            Log.error(e.getMessage());
        }
    }

    // 用户视图
    @RequestMapping("user")
    public String user(HttpServletRequest req, HttpServletResponse resp) {
        Log.info(""); // log
        return "user";
    }

    // 修改密码
    @RequestMapping("user/update")
    @ResponseBody
    public boolean update(HttpServletRequest req, HttpServletResponse resp) {
        String oldPwd = req.getParameter("oldPwd");
        String newPwd = req.getParameter("newPwd");
        Log.info(oldPwd + " " + newPwd); // log

        if (oldPwd != null && newPwd != null && !newPwd.equals(oldPwd)) {
            User user = (User) req.getSession().getAttribute("user");
            oldPwd = Coder.md5(oldPwd + Consts.SALT); // add salt
            // 修改成功
            if (user != null && oldPwd.equals(user.getPassword())) {
                newPwd = Coder.md5(newPwd + Consts.SALT); // add salt
                user.setPassword(newPwd);
                // 更新数据库
                userService.updateUser(user);
                // 更新Session
                req.getSession().setAttribute("user", user);
                return true;
            }
        }
        // 修改失败
        return false;
    }
}