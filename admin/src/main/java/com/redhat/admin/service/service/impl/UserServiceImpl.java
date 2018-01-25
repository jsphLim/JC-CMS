package com.redhat.admin.service.service.impl;

import com.redhat.admin.bean.User;
import com.redhat.admin.dao.UserDao;
import com.redhat.admin.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("userService")
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDao userDao;

    public UserDao getUserDao() {
        return userDao;
    }

    public void setUserDao(UserDao userDao) {
        this.userDao = userDao;
    }

    @Override
    public void saveUser(User user) {
        userDao.save(user);
    }

    @Override
    public void updateUser(User user) {
        userDao.update(user);
    }

    @Override
    public User findUser(String account) {
        String hql = "FROM User WHERE account = ?0";
        return userDao.getByHQL(hql, account);
    }
}