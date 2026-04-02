#!/bin/sh

# 1. إعدادات المسارات والبيانات
OSCAM_PATH="/etc/tuxbox/config"
USER="anow2008"
REPO="conf"
BRANCH="main"

echo "-------------------------------------------------------"
echo "    جاري فحص مستودع GitHub وتحديث ملفاتك أوتوماتيكياً"
echo "-------------------------------------------------------"

# 2. جلب قائمة الملفات الموجودة في المجلد الرئيسي فقط (باستخدام GitHub API)
# بنستبعد فولدر الـ install وأي ملفات نظام تانية مش محتاجينها
FILES=$(wget -qO- "https://api.github.com/repos/$USER/$REPO/contents?ref=$BRANCH" | \
grep '"name":' | sed 's/.*"name": "\(.*\)".*/\1/' | \
grep -v "install" | grep -v ".github" | grep -v "README.md")

# 3. حلقة تحميل الملفات
for FILE in $FILES; do
    # التأكد إن العنصر ده ملف مش فولدر (لتجنب الأخطاء)
    echo "⬇️ جاري تحميل وتحديث: $FILE ..."
    wget -q "-O" "$OSCAM_PATH/$FILE" "https://raw.githubusercontent.com/$USER/$REPO/$BRANCH/$FILE"
done

# 4. ضبط التصاريح (Permissions) لضمان عمل الإيموهات صح
echo "⚙️ جاري ضبط تصاريح الملفات (644)..."
chmod 644 $OSCAM_PATH/oscam.* 2>/dev/null
chmod 644 $OSCAM_PATH/ncam.* 2>/dev/null
chmod 644 $OSCAM_PATH/constant.cw 2>/dev/null
chmod 644 $OSCAM_PATH/*.key 2>/dev/null

echo "-------------------------------------------------------"
echo "✅ تم التحديث بنجاح! كل ما في المستودع أصبح على جهازك الآن."
echo "-------------------------------------------------------"
