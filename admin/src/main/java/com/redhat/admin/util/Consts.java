package com.redhat.admin.util;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.Charset;
import java.util.Properties;

public class Consts {

    private static Properties p;

    // 初始化配置
    static {
        p = new Properties();
        InputStream in = Consts.class.getResourceAsStream("/config.properties");
        InputStreamReader r = new InputStreamReader(in, Charset.forName("UTF-8"));
        try {
            p.load(r);
            in.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // 页面大小
    public static final int PAGE_SIZE = Integer.parseInt(p.getProperty("page.size"));
    // 文件保存路径
    public static final String UPLOAD_PATH = p.getProperty("upload.path");
    // 内存临界值 3M
    public static final int MEMORY_THRESHOLD = Integer.parseInt(p.getProperty("memory.threshold"));
    // 最大上传值 100M
    public static final int MAX_FILE_SIZE = Integer.parseInt(p.getProperty("max.file.size"));
    // 最大请求值 100M
    public static final int MAX_REQUEST_SIZE = Integer.parseInt(p.getProperty("max.request.size"));

    // MD5 盐
    public static final String SALT = p.getProperty("md5.salt");
}