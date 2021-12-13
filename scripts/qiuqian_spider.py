#!/usr/bin/env python3

import re
import json
import time
from urllib.request import urlopen
from bs4 import BeautifulSoup
from pycnnum import num2cn


def parse_one(content):
    if "庞涓观阵" in content:
        idx = content.rfind("庞涓观阵")
        content = content[:idx] + "故事" + content[idx:]

    context_list = re.split("诗曰|签语|解签|仙机|故事|故事不合|诗不合", content)
    for i, s in enumerate(context_list):
        context_list[i] = s.lstrip()                    \
                           .replace("\u3000\r\n", "。") \
                           .replace("\r\n", "。")       \
                           .replace("\u3000", "，")     \
                           .replace("\n", "。")
        if context_list[i].endswith("，"):
            context_list[i] = context_list[i][:-1] + "。"

    res = dict()

    res["rate"] = context_list[0][-2:]
    tmp_lst = context_list[0].split(" ")
    res["phase"] = tmp_lst[-2][-2:]
    res["name"] = tmp_lst[-2][:-2]

    res["poem"] = context_list[1]
    res["word"] = context_list[2]
    res["answer"] = context_list[3]
    res["guide"] = context_list[4]
    res["story"] = context_list[-1]

    return res


def main():
    res = []
    url = "https://m.buyiju.com/guanyin/{}.html"
    for i in range(1, 101):
        print(i)
        html = urlopen(url.format(i))
        obj = BeautifulSoup(html.read(), "html.parser")
        res_ = parse_one(obj.find("div", class_="read-content").text)
        res_["number"] = i
        res_["number_string"] = "第" + num2cn(i) + "签"
        res.append(res_)
        time.sleep(0.1)

    with open("guanyinlingqian.json", "w") as f:
        json.dump(res, f)


if __name__ == "__main__":
    main()
