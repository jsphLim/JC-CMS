package com.redhat.admin.dao.impl;

import com.redhat.admin.bean.User;
import com.redhat.admin.dao.UserDao;
import org.springframework.stereotype.Repository;

@Repository("userDao")
public class UserDaoImpl extends BaseDaoImpl<User> implements UserDao {

}