package com.redhat.admin.service;

import com.redhat.admin.bean.Article;

import java.util.List;

public interface ArticleService {

    public void addArticle(Article ac);

    public void updateArticle(Article ac);

    public void deleteArticle(Article ac);

    public int getRows(String keyword, String type);

    public Article findArticleById(int id);

    public List<Article> queryArticleList(int pageIndex, int pageSize, boolean asc, String keyword, String type);
}