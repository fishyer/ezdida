from apscheduler.schedulers.background import BackgroundScheduler
import time
from ezlogger import print, logger
from main_executor import dida2wf, initwf


def main():
    print(__file__)
    initwf()
    # 先执行一次
    dida2wf()
    # 创建后台调度器,间隔10秒钟执行一次
    scheduler = BackgroundScheduler()
    scheduler.add_job(dida2wf, "cron", second="*/10")
    scheduler.start()
    try:
        while True:
            time.sleep(1)
    except (KeyboardInterrupt, SystemExit):
        scheduler.shutdown()


if __name__ == "__main__":
    main()
