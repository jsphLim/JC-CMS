package com.redhat.admin.util;

public class Test {

    private static String pwd = "123456";

    public static void main(String[] args) {
        String md5 = Coder.md5(pwd); // e10adc3949ba59abbe56e057f20f883e
        System.out.println(md5);

        // add salt
        String md5_salt = Coder.md5(md5 + Consts.SALT); // eb37131695fdc2e808089a14676889e8
        System.out.println(md5_salt);
    }
}