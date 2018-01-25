package com.redhat.admin.util;

import org.apache.commons.codec.digest.DigestUtils;

/**
 * @author littleredhat
 */
public class Coder {

    /**
     * md5 encode
     *
     * @param data 待加密的数据
     * @return 加密后的数据
     */
    public static String md5(String data) {
        return DigestUtils.md5Hex(data);
    }

    /**
     * md5 encode
     *
     * @param data 待加密的数据
     * @return 加密后的数据
     */
    public static String md5(byte[] data) {
        return DigestUtils.md5Hex(data);
    }
}