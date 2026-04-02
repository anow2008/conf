#!/bin/sh

# مسار مجلد الإعدادات في الرسيفر
OSCAM_PATH="/etc/tuxbox/config"

# رابط المستودع (المجلد الرئيسي)
REPO_URL="https://raw.githubusercontent.com/anow2008/conf/main"

echo "------------------------------------------"
echo "  جاري تحديث كافة ملفات OSCam من GitHub"
echo "------------------------------------------"

# قائمة الملفات اللي هتتحمل (زي اللي في الصورة)
FILES="constant.cw oscam.conf oscam.dvbapi oscam.provid oscam.services oscam.srvid oscam.server oscam.user"

for FILE in $FILES; do
    echo "جاري تحميل: $FILE ..."
    wget -q "-O" "$OSCAM_PATH/$FILE" "$REPO_URL/$FILE"
done

# ضبط تصاريح الملفات (644) للقراءة والكتابة
chmod 644 $OSCAM_PATH/oscam.*
chmod 644 $OSCAM_PATH/constant.cw

echo "------------------------------------------"
echo "✅ تم تحديث جميع الملفات بنجاح!"
echo "------------------------------------------"
