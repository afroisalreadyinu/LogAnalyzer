module TestData where

testData = ["Program pid 234 name nginx",
            "Program pid 4592 name apache",
            "Program pid 592 name python",
            "User Ulas did actionA",
            "User Hannes did actionB",
            "User Valerio did actionC",
            "User Yada did actiond",
            "Hologram blah yada"]

moreComplicatedTestData = [
 "Oct 26 06:32:52 api01.production.goodscloud.local uwsgi: [spooler] written 84 bytes to file /var/uwsgi/spool/uwsgi_spoolfile_on_api01.production.goodscloud.local_124420_21_1313171567_1445841172_797233",
 "Oct 26 06:32:52 api01.production.goodscloud.local uwsgi: [spooler /var/uwsgi/spool pid: 25864] managing request uwsgi_spoolfile_on_api01.production.goodscloud.local_124420_21_1313171567_1445841172_797233 ...",
 "Oct 26 06:32:52 api01.production.goodscloud.local uwsgi: [spooler /var/uwsgi/spool pid: 25864] done with task uwsgi_spoolfile_on_api01.production.goodscloud.local_124420_21_1313171567_1445841172_797233 after 0 seconds",
 "Oct 26 06:32:52 api01.production.goodscloud.local uwsgi: [pid: 124420|app: 0|req: 21/1779237] 94.103.18.107 () {38 vars in 934 bytes} [Mon Oct 26 06:32:52 2015] PUT /api/internal/product_description/90475?expires=2015-10-26T14%3A55%3A48Z&key=17eRxHx7AmfPcyxdNK2-0Q&results_per_page=10&token=SpZAvY-L1UHzApvZ8KdwhnFhjYVTBM2YLv4gxE6K6rb4uVk_E2_M0C8WXx8&sign=nPLjjwecR5ke2sEP24N5hO0Vf3o => generated 2453 bytes in 148 msecs (HTTP/1.1 200) 3 headers in 105 bytes (1 switches on core 0)",
 "Oct 26 06:32:52 api02.production.goodscloud.local uwsgi: [spooler] written 82 bytes to file /var/uwsgi/spool/uwsgi_spoolfile_on_api02.production.goodscloud.local_127611_22_1641704722_1445841172_865370",
 "Oct 26 06:32:52 api02.production.goodscloud.local uwsgi: [spooler /var/uwsgi/spool pid: 24885] managing request uwsgi_spoolfile_on_api02.production.goodscloud.local_127611_22_1641704722_1445841172_865370 ...",
 "Oct 26 06:32:52 api02.production.goodscloud.local uwsgi: [spooler /var/uwsgi/spool pid: 24885] done with task uwsgi_spoolfile_on_api02.production.goodscloud.local_127611_22_1641704722_1445841172_865370 after 0 seconds",
 "Oct 26 06:32:52 api02.production.goodscloud.local uwsgi: [pid: 127611|app: 0|req: 22/1779183] 94.103.18.107 () {34 vars in 1396 bytes} [Mon Oct 26 06:32:52 2015] GET /api/internal/channel_product?expires=2015-10-26T14%3A55%3A48Z&key=17eRxHx7AmfPcyxdNK2-0Q&page=1&q=%7B%22filters%22%3A%5B%7B%22name%22%3A%22sku%22%2C%22op%22%3A%22eq%22%2C%22val%22%3A%224046m%22%7D%2C%7B%22name%22%3A%22channel_id%22%2C%22op%22%3A%22eq%22%2C%22val%22%3A24%7D%2C%7B%22name%22%3A%22company_product_id%22%2C%22op%22%3A%22eq%22%2C%22val%22%3A51682%7D%5D%7D&results_per_page=10&token=SpZAvY-L1UHzApvZ8KdwhnFhjYVTBM2YLv4gxE6K6rb4uVk_E2_M0C8WXx8&sign=OglFB%2B2GDFpv0e36ZBW4NiPKj9A => generated 75 bytes in 23 msecs (HTTP/1.1 200) 5 headers in 311 bytes (1 switches on core 0)",
 "Oct 26 06:32:52 work02.production.goodscloud.local runserver 51484  INFO Finished task 4cf96d4e02854338a4d5b9617063d76f in 7,731.5030098 msec",
 "Oct 26 06:32:53 api01.production.goodscloud.local uwsgi: [spooler] written 83 bytes to file /var/uwsgi/spool/uwsgi_spoolfile_on_api01.production.goodscloud.local_124420_22_1926075489_1445841173_24019",
 "Oct 26 06:32:53 api01.production.goodscloud.local uwsgi: [spooler /var/uwsgi/spool pid: 25864] managing request uwsgi_spoolfile_on_api01.production.goodscloud.local_124420_22_1926075489_1445841173_24019 ...",
 "Oct 26 06:32:53 api01.production.goodscloud.local uwsgi: [spooler /var/uwsgi/spool pid: 25864] done with task uwsgi_spoolfile_on_api01.production.goodscloud.local_124420_22_1926075489_1445841173_24019 after 0 seconds",
 "Oct 26 06:32:53 api01.production.goodscloud.local uwsgi: [pid: 124420|app: 0|req: 22/1779238] 94.103.18.107 () {34 vars in 1102 bytes} [Mon Oct 26 06:32:52 2015] GET /api/internal/company_product?expires=2015-10-26T14%3A55%3A48Z&flat=true&key=17eRxHx7AmfPcyxdNK2-0Q&page=1&q=%7B%22filters%22%3A%5B%7B%22name%22%3A%22ean%22%2C%22op%22%3A%22eq%22%2C%22val%22%3A%228716716040569%22%7D%5D%7D&results_per_page=10&token=SpZAvY-L1UHzApvZ8KdwhnFhjYVTBM2YLv4gxE6K6rb4uVk_E2_M0C8WXx8&sign=Lg%2BkUyedAramB6bBCaWoIRQpB44 => generated 869 bytes in 57 msecs (HTTP/1.1 200) 5 headers in 312 bytes (1 switches on core 0)",
 "Oct 26 06:32:53 psqldb.production.goodscloud.local postgres[130443]: [3-1] 2015-10-26 06:32:53 UTC LOG:  could not receive data from client: Connection reset by peer"]
