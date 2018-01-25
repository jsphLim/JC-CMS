package com.redhat.admin.service.service.impl;

import com.redhat.admin.bean.Article;
import com.redhat.admin.dao.ArticleDao;
import com.redhat.admin.service.ArticleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("articleService")
public class ArticleServiceImpl implements ArticleService {

    @Autowired
    private ArticleDao articleDao;

    public ArticleDao getArticleDao() {
        return articleDao;
    }

    public void setArticleDao(ArticleDao articleDao) {
        this.articleDao = articleDao;
    }

    @Override
    public void addArticle(Article ac) {
        articleDao.save(ac);
    }

    @Override
    public void updateArticle(Article ac) {
        articleDao.update(ac);
    }

    @Override
    public void deleteArticle(Article ac) {
        articleDao.delete(ac);
    }

    @Override
    public int getRows(String keyword, String type) {
        String hql = "FROM Article WHERE type = ?0";
        if (keyword != null && !keyword.isEmpty())
            hql += String.format(" AND (title LIKE '%%%s%%' OR author LIKE '%%%s%%' OR date LIKE '%%%s%%' OR content LIKE '%%%s%%' OR url LIKE '%%%s%%')", keyword, keyword, keyword, keyword, keyword);
        return articleDao.getRows(hql, type);
    }

    @Override
    public Article findArticleById(int id) {
        return articleDao.findById(id);
    }

    @Override
    public List<Article> queryArticleList(int pageIndex, int pageSize, boolean asc, String keyword, String type) {
        String hql = "FROM Article WHERE type = ?0";
        if (keyword != null && !keyword.isEmpty())
            hql += String.format(" AND (title LIKE '%%%s%%' OR author LIKE '%%%s%%' OR date LIKE '%%%s%%' OR content LIKE '%%%s%%' OR url LIKE '%%%s%%')", keyword, keyword, keyword, keyword, keyword);
        if (!asc)
            hql += " ORDER BY id DESC";
        return articleDao.queryListObjectAllForPage(pageIndex, pageSize, hql, type);
    }
}