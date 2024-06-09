# from jianguo_api.jianguo.api.core import Jianguo as Jianguo
from webdav4.client import Client
import os
import env_client
from fish_util.src.loguru_util import print, debug, info, error, warning, info, logger
import logging

# 设置日志级别为DEBUG
logging.basicConfig(level=logging.DEBUG)

client = Client(
    base_url=env_client.cd_hostname,
    auth=(env_client.cd_username, env_client.cd_password),
)

remote_folder = "MyNote/clipper"


def check_remote_folder():
    # 尝试列出根目录下的文件和文件夹，以验证登录是否成功
    try:
        files = client.ls("/")
        for file in files:
            # print(file["name"], file["href"], file["type"])
            print(f"文件 {file['name']} {file['href']} {file['type']}")
            if file["name"] == remote_folder:
                print(f"找到了 {remote_folder} 文件夹")
                return True
        print(f"未找到 {remote_folder} 文件夹，尝试创建")
        client.mkdir(remote_folder)
        print(f"创建 {remote_folder} 文件夹成功")
        return True
    except Exception as e:
        error(f"check_remote_folder错误")
        logger.exception(e)
        return False


def upload_file(local_path, remote_path):
    try:
        client.upload_file(from_path=local_path, to_path=remote_path, overwrite=False)
        print(f"文件 {local_path} 已成功上传到 {remote_path}")
        return True
    except Exception as e:
        print("上传失败，错误:", e)
        return False


def sync_files_to_webdav(local_path, remote_path):
    for root, dirs, files in os.walk(local_path):
        remote_dir = remote_path + root.replace(local_path, "").replace("\\", "/")
        try:
            client.mkdir(remote_dir)
            print(f"根据文件夹 {root} 创建远程文件夹 {remote_dir}")
        except Exception as e:
            print(f"同步文件夹 {root} 失败，错误: {e}")

        for file in files:
            local_file = os.path.join(root, file)
            remote_file = remote_path + local_file.replace(local_path, "").replace(
                "\\", "/"
            )
            try:
                client.upload_file(
                    from_path=local_file, to_path=remote_file, overwrite=True
                )
                print(f"文件 {local_file} 已成功同步到 {remote_file}")
            except Exception as e:
                print(f"同步文件 {local_file} 失败，错误: {e}")

        for d in dirs:
            sync_files_to_webdav(os.path.join(root, d), remote_path)


result = check_remote_folder()
info(f"检查缓存文件夹结果: {result}")


def main():
    print(__file__)
    local_path = "cache/md/archive/2个阅读源码的小技巧.md"
    remote_path = remote_folder + "/2个阅读源码的小技巧-2024-06-09.md"
    upload_file(local_path, remote_path)
    # sync_files_to_webdav("cache/md", "/clipper")


if __name__ == "__main__":
    main()
