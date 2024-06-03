from dotenv import load_dotenv
import os

# 加载.env文件
load_dotenv()

# 读取并打印环境变量
"""
build_type = "dev"
ob_vault = "MyNote"
DIDA_ACCESS_TOKEN="3ad46d12-a0d6-454d-8ccc-e3bbce0aa943"
DIDA_INBOX_ID="inbox1010592152"
WF_SESSION_ID="bza32axq7bbzt9w5h1k6b163v017jviz"
WF_INBOX_NAME="滴答清单-Inbox"
"""

build_type = os.getenv("build_type")
print(f"build_type: {build_type}")

ob_vault = os.getenv("ob_vault")
print(f"ob_vault: {ob_vault}")


DIDA_ACCESS_TOKEN = os.getenv("DIDA_ACCESS_TOKEN")
print(f"DIDA_ACCESS_TOKEN: {DIDA_ACCESS_TOKEN}")

DIDA_INBOX_ID = os.getenv("DIDA_INBOX_ID")
print(f"DIDA_INBOX_ID: {DIDA_INBOX_ID}")

WF_SESSION_ID = os.getenv("WF_SESSION_ID")
print(f"WF_SESSION_ID: {WF_SESSION_ID}")

WF_INBOX_NAME = os.getenv("WF_INBOX_NAME")
print(f"WF_INBOX_NAME: {WF_INBOX_NAME}")
