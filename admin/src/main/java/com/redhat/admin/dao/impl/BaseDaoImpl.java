package com.redhat.admin.dao.impl;

import com.redhat.admin.dao.BaseDao;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.io.Serializable;
import java.lang.reflect.ParameterizedType;
import java.util.List;

public class BaseDaoImpl<T> implements BaseDao<T> {

    @Resource
    private SessionFactory sessionFactory;
    protected Class<T> entityClass;

    public SessionFactory getSessionFactory() {
        return sessionFactory;
    }

    public void setSessionFactory(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public Session getCurrentSession() {
        return this.sessionFactory.getCurrentSession();
    }

    protected Class<T> getEntityClass() {
        if (entityClass == null) {
            entityClass = (Class<T>) ((ParameterizedType) getClass().getGenericSuperclass())
                    .getActualTypeArguments()[0];
        }
        return entityClass;
    }

    @Transactional
    public Serializable save(T entity) {
        return this.getCurrentSession().save(entity);
    }

    @Transactional
    public void delete(T entity) {
        this.getCurrentSession().delete(entity);
    }

    @Transactional
    public void update(T entity) {
        this.getCurrentSession().update(entity);
    }

    @Transactional
    public T findById(Serializable id) {
        T load = (T) this.getCurrentSession().get(getEntityClass(), id);
        return load;
    }

    /**
     * <根据HQL语句查找唯一实体>
     *
     * @param hqlString HQL语句
     * @param values    不定参数的Object数组
     * @return 查询实体
     */
    @Transactional
    public T getByHQL(String hqlString, Object... values) {
        Query<T> query = this.getCurrentSession().createQuery(hqlString);
        if (values != null) {
            for (int i = 0; i < values.length; i++) {
                query.setParameter(i, values[i]);
            }
        }
        return (T) query.uniqueResult();
    }

    /**
     * <根据SQL语句查找唯一实体>
     *
     * @param sqlString SQL语句
     * @param values    不定参数的Object数组
     * @return 查询实体
     */
    @Transactional
    public T getBySQL(String sqlString, Object... values) {
        Query<T> query = this.getCurrentSession().createSQLQuery(sqlString);
        if (values != null) {
            for (int i = 0; i < values.length; i++) {
                query.setParameter(i, values[i]);
            }
        }
        return (T) query.uniqueResult();
    }

    /**
     * <根据HQL语句，得到对应的list>
     *
     * @param hqlString HQL语句
     * @param values    不定参数的Object数组
     * @return 查询多个实体的List集合
     */
    @Transactional
    public List<T> getListByHQL(String hqlString, Object... values) {
        Query<T> query = this.getCurrentSession().createQuery(hqlString);
        if (values != null) {
            for (int i = 0; i < values.length; i++) {
                query.setParameter(i, values[i]);
            }
        }
        return query.list();
    }

    /**
     * <根据SQL语句，得到对应的list>
     *
     * @param sqlString SQL语句
     * @param values    不定参数的Object数组
     * @return 查询多个实体的List集合
     */
    @Transactional
    public List<T> getListBySQL(String sqlString, Object... values) {
        Query<T> query = this.getCurrentSession().createSQLQuery(sqlString);
        if (values != null) {
            for (int i = 0; i < values.length; i++) {
                query.setParameter(i, values[i]);
            }
        }
        return query.list();
    }

    @Transactional
    public List<T> queryListObjectAllForPage(int pageIndex, int pageSize, String sqlString, Object... values) {
        Query<T> query = this.getCurrentSession().createQuery(sqlString);
        if (values != null) {
            for (int i = 0; i < values.length; i++) {
                query.setParameter(i, values[i]);
            }
        }
        query.setFirstResult(pageIndex * pageSize);
        query.setMaxResults(pageSize);
        return query.list();
    }

    @Transactional
    public int getRows(String sqlString, Object... values) {
        Query<T> query = this.getCurrentSession().createQuery(sqlString);
        if (values != null) {
            for (int i = 0; i < values.length; i++) {
                query.setParameter(i, values[i]);
            }
        }
        return new Integer(query.list().size());
    }
}