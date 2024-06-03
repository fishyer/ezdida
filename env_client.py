from dotenv import load_dotenv
import os

# 加载.env文件
load_dotenv()

# 读取并打印环境变量
"""
build_type = "dev"
ob_vault = "MyNote"
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

webdav_hostname = os.getenv("webdav_hostname")
print(f"webdav_hostname: {webdav_hostname}")

webdav_username = os.getenv("webdav_username")
print(f"webdav_username: {webdav_username}")

webdav_password = os.getenv("webdav_password")
print(f"webdav_password: {webdav_password}")
