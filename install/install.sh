#!/bin/sh

# مسار مجلد الإعدادات في الرسيفر
OSCAM_PATH="/etc/tuxbox/config"

# رابط المجلد الرئيسي للمستودع
REPO_URL="https://raw.githubusercontent.com/anow2008/conf/main"

echo "------------------------------------------"
echo "  جاري تحديث الملفات المحددة في الصورة"
echo "------------------------------------------"

# القائمة دي مطابقة تماماً للصورة (6 ملفات فقط)
FILES="constant.cw oscam.conf oscam.dvbapi oscam.provid oscam.services oscam.srvid"

for FILE in $FILES; do
    echo "جاري تحميل: $FILE ..."
    wget -q "-O" "$OSCAM_PATH/$FILE" "$REPO_URL/$FILE"
done

# ضبط تصاريح الملفات عشان تشتغل صح
chmod 644 $OSCAM_PATH/oscam.conf
chmod 644 $OSCAM_PATH/oscam.dvbapi
chmod 644 $OSCAM_PATH/oscam.provid
chmod 644 $OSCAM_PATH/oscam.services
chmod 644 $OSCAM_PATH/oscam.srvid
chmod 644 $OSCAM_PATH/constant.cw

echo "------------------------------------------"
echo "✅ تم التحديث بنجاح! الملفات الآن مطابقة لـ GitHub"
echo "------------------------------------------"
