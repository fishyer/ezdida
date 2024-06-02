from wfapi import *
import dida_client
from dida_client import DidaTask
import re
import time
import urllib3
import decorator_util
from ezlogger import print, logger
from dotenv import load_dotenv
import os

# 加载.env文件
load_dotenv()

# 从环境变量中读取TOKEN
DIDA_ACCESS_TOKEN = os.getenv("DIDA_ACCESS_TOKEN")
DIDA_INBOX_ID = os.getenv("DIDA_INBOX_ID")
WF_INBOX_NAME = os.getenv("WF_INBOX_NAME")
WF_SESSION_ID = os.getenv("WF_SESSION_ID")

print(f"DIDA_ACCESS_TOKEN: {DIDA_ACCESS_TOKEN}")
print(f"DIDA_INBOX_ID: {DIDA_INBOX_ID}")
print(f"WF_INBOX_NAME: {WF_INBOX_NAME}")
print(f"WF_SESSION_ID: {WF_SESSION_ID}")

# 禁止显示urllib3库发出的关于不安全请求的警告信息
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


# 添加WF节点
def add(node: Node, title: str, content: str = None):
    sub_node = node.create()
    sub_node.edit(title)
    if content:
        sub_node.description = content
    return sub_node


@decorator_util.trace_exception
@decorator_util.trace_retry(3, 5)
def process_dida_task(inbox, task: DidaTask):
    dida_title, dida_url = preprocess(task.title, task.content)
    if dida_url:
        # 添加wf节点
        node = add(inbox, dida_title, dida_url)
        # 删除滴答清单任务
        dida_client.delete_task(DIDA_ACCESS_TOKEN, DIDA_INBOX_ID, task.id)
    else:
        print(f"No url found in {task.title}")


# 预处理，从滴答清单的标题和内容中提取出title和url
def preprocess(title, content):
    if match := re.match(r"\[(.*?)\]\((.*?)\)", title):
        return match.group(1), match.group(2)
    if content is not None and content.startswith("http"):
        return title, content
    if title is not None and title.startswith("http"):
        return title, title
    return None, None


@decorator_util.trace_exception
@decorator_util.trace_retry(3, 5)
def get_wf():
    wf = Workflowy(sessionid=WF_SESSION_ID)
    return wf


def get_dida_inbox(wf: Workflowy):
    root = wf.root
    inbox_name = WF_INBOX_NAME
    for child in root:
        if child.name == inbox_name:
            print(f"Inbox exists: {child.name}")
            return child
    inbox = root.create()
    inbox.edit(inbox_name)
    print(f"Inbox created: {inbox.name}")
    return inbox


def dida2wf():
    inbox_tasks = dida_client.get_project_by_id(DIDA_ACCESS_TOKEN, DIDA_INBOX_ID)
    print(f"Inbox Tasks: {len(inbox_tasks)}")
    for i, task in enumerate(inbox_tasks):
        print(f"{i+1}. {task.title}")
        process_dida_task(inbox, task)
        # 等待1秒，防止滴答清单接口频繁请求而报错500
        time.sleep(1)
    print("Export Dida[inbox] to Workflowy Done.")


def initwf():
    global wf, inbox
    print("Start to connect to Workflowy...")
    wf = get_wf()
    print("Connected to Workflowy.")
    inbox = get_dida_inbox(wf)
    print(f"Inbox: {inbox.name}")


def main():
    print(__file__)
    initwf()
    dida2wf()


if __name__ == "__main__":
    main()
