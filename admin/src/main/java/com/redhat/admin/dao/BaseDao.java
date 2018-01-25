package com.redhat.admin.dao;

import java.io.Serializable;
import java.util.List;

public interface BaseDao<T> {

    public Serializable save(T entity);

    public void delete(T entity);

    public void update(T entity);

    public T findById(Serializable id);

    public T getByHQL(String hqlString, Object... values);

    public T getBySQL(String sqlString, Object... values);

    public List<T> getListByHQL(String hqlString, Object... values);

    public List<T> getListBySQL(String sqlString, Object... values);

    public List<T> queryListObjectAllForPage(int pageSize, int page, String sqlString, Object... values);

    public int getRows(String sqlString, Object... values);
}