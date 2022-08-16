import http from 'k6/http';

import { sleep, check } from 'k6';

import { Counter } from 'k6/metrics';


// A simple counter for http requests


export const requests = new Counter('http_reqs');



export function setup() {
    // 2. setup code, you can pass data to VU and teardown
    sleep(3)
    return true
  }
  

// you can specify stages of your test (ramp up/down patterns) through the options object

// target is the number of VUs you are aiming for


export const options = {

  stages: [

    { target: 20, duration: '1m' },

    { target: 15, duration: '1m' },

    { target: 0, duration: '1m' },

  ],

  thresholds: {

    requests: ['count < 100'],

    http_req_failed: ['rate<0.01'], // http errors should be less than 1%

    http_req_duration: ['p(95)<200'], // 95% of requests should be below 200ms



  },

};


export default function () {

  // our HTTP request, note that we are saving the response to res, which can be accessed later


  const res = http.get('http://web:8000/status');


  //sleep(1);


  const checkRes = check(res, {

    'status is 200': (r) => r.status === 200,

    'response body': (r) => r.body.indexOf('Up and running') !== -1,

  });

}