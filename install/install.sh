#!/bin/sh

# مسار الإعدادات في الرسيفر
OSCAM_PATH="/etc/tuxbox/config"

# بيانات المستودع بتاعك
USER="anow2008"
REPO="conf"
BRANCH="main"

echo "------------------------------------------"
echo "  جاري فحص المستودع وتحميل كافة الملفات"
echo "------------------------------------------"

# خطوة ذكية: بجيب قائمة بأسماء الملفات اللي في المجلد الرئيسي فقط (بدون الفولدرات)
FILES=$(wget -qO- "https://api.github.com/repos/$USER/$REPO/contents?ref=$BRANCH" | grep '"name":' | sed 's/.*"name": "\(.*\)".*/\1/' | grep -v "install")

for FILE in $FILES; do
    # التأكد إننا بنحمل ملفات مش فولدرات (عشان نتجنب المشاكل)
    if [ "$FILE" != "README.md" ] && [ "$FILE" != ".github" ]; then
        echo "جاري تحميل: $FILE ..."
        wget -q "-O" "$OSCAM_PATH/$FILE" "https://raw.githubusercontent.com/$USER/$REPO/$BRANCH/$FILE"
    fi
done

# ضبط التصاريح لكل الملفات اللي بدأت بـ oscam أو constant
chmod 644 $OSCAM_PATH/oscam.* 2>/dev/null
chmod 644 $OSCAM_PATH/constant.cw 2>/dev/null

echo "------------------------------------------"
echo "✅ تم تحديث كل شيء موجود في المستودع بنجاح!"
echo "------------------------------------------"
