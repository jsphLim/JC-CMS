package com.redhat.admin.dao.impl;

import com.redhat.admin.bean.Article;
import com.redhat.admin.dao.ArticleDao;
import org.springframework.stereotype.Repository;

@Repository("articleDao")
public class ArticleDaoImpl extends BaseDaoImpl<Article> implements ArticleDao {

}