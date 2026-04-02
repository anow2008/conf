#!/bin/sh

# تحديد المسارات
OSCAM_PATH="/etc/tuxbox/config"
REPO_URL="https://raw.githubusercontent.com/anow2008/conf/main"

echo "------------------------------------------"
echo "  جاري تحميل وتحديث ملفات OSCam من GitHub"
echo "------------------------------------------"

# تحميل الملفات الأساسية (تأكد من وجود هذه الملفات في المستودع)
wget -q "-O" "$OSCAM_PATH/oscam.conf" "$REPO_URL/oscam.conf"
wget -q "-O" "$OSCAM_PATH/oscam.server" "$REPO_URL/oscam.server"
wget -q "-O" "$OSCAM_PATH/oscam.user" "$REPO_URL/oscam.user"
wget -q "-O" "$OSCAM_PATH/oscam.dvbapi" "$REPO_URL/oscam.dvbapi"

# إعطاء تصريح القراءة والكتابة للملفات (644)
chmod 644 $OSCAM_PATH/oscam.*

echo ">>> تم تحديث الملفات بنجاح في المسار: $OSCAM_PATH"
echo ">>> يرجى عمل Restart للـ OSCam لتفعيل التعديلات."
echo "------------------------------------------"
