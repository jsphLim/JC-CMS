package com.redhat.admin.service;

import com.redhat.admin.bean.User;

public interface UserService {

    public void saveUser(User user);

    public void updateUser(User user);

    public User findUser(String account);
}