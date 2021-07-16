#!/usr/bin/env python

import unittest
import os
import requests
import re
import time


class TestName(unittest.TestCase):
    url = os.getenv('SERVICE_URL', 'http://127.0.0.1:8000')
    time.sleep(10)
    def test_status(self):
        url = self.url + "/status"
        response = requests.get(url, timeout=1)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.encoding, 'ISO-8859-1')
        self.assertTrue(re.match('Up and running', response.text))


if __name__ == '__main__':
    unittest.main()
