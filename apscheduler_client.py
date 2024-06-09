from apscheduler.schedulers.background import BackgroundScheduler
import time
from ezlogger import print, debug, error, warning, info
from workflowy_client import init_wf, refresh_inbox, dida2wf, wf2ob
import logging

# 设置日志级别为DEBUG
logging.basicConfig(level=logging.DEBUG)

execute_count = 0


def execute_job():
    global execute_count
    execute_count += 1
    info(f"execute_count: {execute_count} remainder: {execute_count % 6}")
    dida2wf()
    # 每执行5次dida2wf后，就执行1次wf2ob,干掉漏网之鱼
    if execute_count % 5 == 0:
        refresh_inbox()
        wf2ob()


def main():
    print(__file__)
    init_wf()
    refresh_inbox()
    # 先执行一次
    execute_job()
    # 创建后台调度器,间隔10秒钟执行一次
    scheduler = BackgroundScheduler()
    scheduler.add_job(execute_job, "cron", second="*/10")
    scheduler.start()
    try:
        while True:
            time.sleep(1)
    except (KeyboardInterrupt, SystemExit):
        scheduler.shutdown()


if __name__ == "__main__":
    main()
