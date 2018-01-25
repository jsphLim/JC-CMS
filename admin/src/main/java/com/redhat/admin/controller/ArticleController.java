package com.redhat.admin.controller;

import com.alibaba.fastjson.JSON;
import com.redhat.admin.bean.Article;
import com.redhat.admin.bean.Page;
import com.redhat.admin.service.ArticleService;
import com.redhat.admin.util.Consts;
import com.redhat.admin.util.Log;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("article")
public class ArticleController {

    @Autowired
    private ArticleService articleService;

    /*
     * type = lb st zxzx mtbd xmdt
     * 类型 = 轮播 三图 最新资讯 媒体报道 项目动态
     */
    @RequestMapping("")
    public String list(HttpServletRequest req, HttpServletResponse resp) {
        String type = req.getParameter("type");
        String _pageIndex = req.getParameter("page");
        String _asc = req.getParameter("asc");
        String keyword = req.getParameter("keyword");
        Log.info(type + " " + _pageIndex + " " + _asc + " " + keyword); // log

        if (type != null && (type.equals("lb") || type.equals("st") || type.equals("zxzx") || type.equals("mtbd") || type.equals("xmdt"))) {
            int pageIndex = 0;
            boolean asc = false;
            if (_pageIndex != null)
                pageIndex = Integer.parseInt(_pageIndex);
            if (_asc != null)
                asc = Boolean.parseBoolean(_asc);

            Page page = new Page();
            page.setPageIndex(pageIndex); // 当前页面
            page.setPageSize(Consts.PAGE_SIZE); // 页面大小
            page.setTotalCount(articleService.getRows(keyword, type)); // 文章数量
            page.setAsc(asc); // 是否顺序
            page.setKeyword(keyword); // 关键字
            page.setList(articleService.queryArticleList(pageIndex, Consts.PAGE_SIZE, asc, keyword, type)); // 文章列表

            Log.info(page); // log test
            req.getSession().setAttribute("page", page);
            return type;
        }
        return "user";
    }

    // 获取文章
    @RequestMapping("get")
    @ResponseBody
    public String get(HttpServletRequest req, HttpServletResponse resp) {
        String _id = req.getParameter("id");
        Log.info(_id); // log

        if (_id != null) {
            int id = Integer.parseInt(_id);
            Article ac = articleService.findArticleById(id);
            if (ac != null) {
                Log.info(ac); // log test
                return JSON.toJSONString(ac);
            }
        }
        return null;
    }

    // 添加文章
    @RequestMapping("add")
    @ResponseBody
    public boolean add(HttpServletRequest req, HttpServletResponse resp) {
        // 上传目录
        String rootPath = req.getServletContext().getRealPath("/");
        File file = new File(rootPath + Consts.UPLOAD_PATH);
        // 判断是否存在目录
        if (!file.exists() && !file.isDirectory()) {
            file.mkdir();
        }

        DiskFileItemFactory factory = new DiskFileItemFactory();
        // 设置临时目录
        factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
        // 设置内存临界值
        factory.setSizeThreshold(Consts.MEMORY_THRESHOLD);

        ServletFileUpload upload = new ServletFileUpload(factory);
        // 设置进度监听器
        // upload.setProgressListener(new UploadListener(request));
        // 设置最大上传值
        upload.setFileSizeMax(Consts.MAX_FILE_SIZE);
        // 设置最大请求值
        upload.setSizeMax(Consts.MAX_REQUEST_SIZE);

        // 中文处理
        upload.setHeaderEncoding("UTF-8");

        // ####################
        Article ac = new Article();
        // ####################

        try {
            // 解析请求的内容提取文件数据
            List<FileItem> formItems = upload.parseRequest(req);
            if (formItems != null && formItems.size() > 0) {
                // 迭代表单数据
                for (FileItem item : formItems) {
                    // 处理不在表单中的字段
                    if (!item.isFormField()) {
                        // 获取扩展名
                        String ext = item.getName().substring(item.getName().lastIndexOf(".") + 1);
                        if (!ext.equals("jpg") && !ext.equals("png") && !ext.equals("bmp")) return false;

                        // UUID
                        String uuid = UUID.randomUUID().toString();
                        // 组合名
                        String name = Consts.UPLOAD_PATH + "/" + uuid + "." + ext;

                        // 打开输入流
                        InputStream in = item.getInputStream();
                        // 打开输出流
                        FileOutputStream out = new FileOutputStream(rootPath + name);

                        byte buffer[] = new byte[1024];
                        // 当前流位置
                        int len = 0;
                        while ((len = in.read(buffer)) > 0) {
                            out.write(buffer, 0, len);
                        }
                        // 关闭输入流
                        in.close();
                        // 关闭输出流
                        out.close();
                        // 删除记录
                        item.delete();

                        // 记录封面
                        ac.setImage(name);
                    } else if (item.isFormField()) {
                        // 记录信息
                        switch (item.getFieldName()) {
                            case "title":
                                ac.setTitle(item.getString("UTF-8"));
                                break;
                            case "author":
                                ac.setAuthor(item.getString("UTF-8"));
                                break;
                            case "date":
                                ac.setDate(item.getString("UTF-8"));
                                break;
                            case "content":
                                ac.setContent(item.getString("UTF-8"));
                                break;
                            case "url":
                                ac.setUrl(item.getString("UTF-8"));
                                break;
                            case "type":
                                ac.setType(item.getString("UTF-8"));
                                break;
                        }
                    }
                }
            }

            Log.info(ac); // log test
            articleService.addArticle(ac); // 更新数据库
            return true;
        } catch (Exception e) {
            Log.error(e.getMessage());
        }
        return false;
    }

    // 修改信息
    @RequestMapping("update")
    @ResponseBody
    public boolean update(HttpServletRequest req, HttpServletResponse resp) {
        String _id = req.getParameter("id");
        String title = req.getParameter("title");
        String author = req.getParameter("author");
        String date = req.getParameter("date");
        String content = req.getParameter("content");
        String url = req.getParameter("url");
        String type = req.getParameter("type");
        Log.info(_id + " " + title + " " + author + " " + date + " " + content + " " + url + " " + type); // log

        if (_id != null) {
            int id = Integer.parseInt(_id);
            Article ac = articleService.findArticleById(id);
            if (ac != null && (type.equals("lb") || type.equals("st") || type.equals("zxzx") || type.equals("mtbd") || type.equals("xmdt"))) {
                ac.setTitle(title);
                ac.setAuthor(author);
                ac.setDate(date);
                ac.setContent(content);
                ac.setUrl(url);
                articleService.updateArticle(ac); // 更新数据库
                return true;
            }
        }
        return false;
    }

    // 修改封面
    @RequestMapping("updateImage")
    @ResponseBody
    public boolean updateImage(HttpServletRequest req, HttpServletResponse resp) {
        // 上传目录
        String rootPath = req.getServletContext().getRealPath("/");
        File file = new File(rootPath + Consts.UPLOAD_PATH);
        // 判断是否存在目录
        if (!file.exists() && !file.isDirectory()) {
            file.mkdir();
        }

        DiskFileItemFactory factory = new DiskFileItemFactory();
        // 设置临时目录
        factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
        // 设置内存临界值
        factory.setSizeThreshold(Consts.MEMORY_THRESHOLD);

        ServletFileUpload upload = new ServletFileUpload(factory);
        // 设置进度监听器
        // upload.setProgressListener(new UploadListener(request));
        // 设置最大上传值
        upload.setFileSizeMax(Consts.MAX_FILE_SIZE);
        // 设置最大请求值
        upload.setSizeMax(Consts.MAX_REQUEST_SIZE);

        // 中文处理
        upload.setHeaderEncoding("UTF-8");

        // ####################
        int id = -1;
        String name = "";
        // ####################

        try {
            // 解析请求的内容提取文件数据
            List<FileItem> formItems = upload.parseRequest(req);
            if (formItems != null && formItems.size() > 0) {
                // 迭代表单数据
                for (FileItem item : formItems) {
                    // 处理不在表单中的字段
                    if (!item.isFormField()) {
                        // 获取扩展名
                        String ext = item.getName().substring(item.getName().lastIndexOf(".") + 1);
                        if (!ext.equals("jpg") && !ext.equals("png") && !ext.equals("bmp")) return false;

                        // UUID
                        String uuid = UUID.randomUUID().toString();
                        // 组合名
                        name = Consts.UPLOAD_PATH + "/" + uuid + "." + ext;

                        // 打开输入流
                        InputStream in = item.getInputStream();
                        // 打开输出流
                        FileOutputStream out = new FileOutputStream(rootPath + "/" + name);
                        byte buffer[] = new byte[1024];
                        // 当前流位置
                        int len = 0;
                        while ((len = in.read(buffer)) > 0) {
                            out.write(buffer, 0, len);
                        }
                        // 关闭输入流
                        in.close();
                        // 关闭输出流
                        out.close();
                        // 删除记录
                        item.delete();
                    } else if (item.isFormField()) {
                        // 记录信息
                        if (item.getFieldName().equals("id")) {
                            id = Integer.parseInt(item.getString("UTF-8"));
                        }
                    }
                }
            }

            Log.info(id + " " + name); // log test
            Article ac = articleService.findArticleById(id);
            if (ac != null) {
                ac.setImage(name);
                articleService.updateArticle(ac); // 更新数据库
                return true;
            }
        } catch (Exception e) {
            Log.error(e.getMessage());
        }
        return false;
    }

    // 删除文章
    @RequestMapping("delete")
    @ResponseBody
    public boolean delete(HttpServletRequest req, HttpServletResponse resp) {
        String _id = req.getParameter("id");
        Log.info(_id); // log

        if (_id != null) {
            int id = Integer.parseInt(_id);
            Article ac = articleService.findArticleById(id);
            if (ac != null) {
                articleService.deleteArticle(ac); // 更新数据库
                return true;
            }
        }
        return false;
    }
}