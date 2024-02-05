import urlgrabber

def download_file(url, dest_path):
    try:
        urlgrabber.urlgrab(url, dest=dest_path)
        print("文件下载成功！")
    except Exception as e:
        print("文件下载失败：", str(e))

url = "https://www.baidu.com/"
dest_path = ""

download_file(url, dest_path)
