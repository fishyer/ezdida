import re


def main():
    print(__file__)
    text = r'[文章标题](<a href="https://juejin.cn">https://juejin.cn/post/7373831659470880806</a>)'
    print(text)
    match = re.match(r"\[(.*?)\]\(<a\s+href=\".*?\">(.*?)</a>\)", text)
    # 提取匹配到的结果
    if match:
        article_title = match.group(1)
        article_link = match.group(2)
        print(article_title)
        print(article_link)
    else:
        print("未匹配到结果")


if __name__ == "__main__":
    main()
