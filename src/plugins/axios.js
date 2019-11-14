"use strict";

import axios from "axios";
import iView from 'iview'

// Full config:  https://github.com/axios/axios#request-config
// axios.defaults.baseURL = process.env.baseURL || process.env.apiUrl || '';
// axios.defaults.headers.common['Authorization'] = AUTH_TOKEN;
// axios.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded';

let config = {
  baseURL: "/api"
  // timeout: 60 * 1000, // Timeout
  // withCredentials: true, // Check cross-site Access-Control
};

const _axios = axios.create(config);

_axios.interceptors.request.use(
  function(config) {
    // Do something before request is sent
    return config;
  },
  function(error) {
    // Do something with request error
    return Promise.reject(error);
  }
);

// Add a response interceptor
_axios.interceptors.response.use(
  function(response) {
    // Do something with response data
    switch(response.data.resultFlag){
      case 0:
        iView.Message.error("服务器出错！")
        break;
      case 10000:
        if (response.data.msg){
          let msg = response.data.msg
          if(msg.search('important:')>-1){
            msg = msg.substring(15)
            iView.Modal.warning({
              title: '警告',
              content: msg
            });
          }else{
            iView.Message.info(response.data.msg)
          }
          
        }
        break;
      case 30000:
        let msg= '未找到数据'
        if(response.data.msg!=undefined){
          msg = response.data.msg
        }
        if(msg){
          iView.Message.info(msg)
        }
        break;
    }
    return response;
  },
  function(error) {
    // Do something with response error
    iView.Message.error("请求服务器出错！")
    return Promise.reject(error);
  }
);


export default _axios;
