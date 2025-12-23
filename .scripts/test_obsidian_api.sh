#!/bin/bash
# Obsidian Local REST API 연동 테스트 스크립트

API_URL="https://127.0.0.1:27124"
API_KEY="68b243f4d0009646914570125cc8658dd677f26f0295d38b6d39d4106b27c7a4"
TEST_FILE="NotebookLM/API_테스트_노트.md"

echo "========================================="
echo "Obsidian Local REST API 연동 테스트"
echo "========================================="

# 테스트 Markdown 내용
read -r -d '' MARKDOWN_CONTENT << 'EOF'
---
created: 2025-12-18 16:30:00
source: API Test
tags: [test, api]
---

# API 테스트 노트

이 노트는 Obsidian Local REST API 연동 테스트를 위해 생성되었습니다.

## 테스트 항목

- ✅ REST API 연결
- ✅ 파일 생성
- ✅ Frontmatter 인식
- ✅ 한글 인코딩

**테스트 시간**: $(date '+%Y-%m-%d %H:%M:%S')
EOF

echo ""
echo "📝 테스트 노트 내용:"
echo "---"
echo "$MARKDOWN_CONTENT"
echo "---"
echo ""

echo "🔄 Obsidian API에 파일 생성 요청 중..."
echo "   URL: $API_URL/vault/$TEST_FILE"
echo ""

# API 요청 (자체 서명 인증서 허용)
RESPONSE=$(curl -k -s -w "\nHTTP_STATUS:%{http_code}" \
  -X PUT \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: text/markdown" \
  --data-binary "$MARKDOWN_CONTENT" \
  "$API_URL/vault/$TEST_FILE")

# HTTP 상태 코드 추출
HTTP_STATUS=$(echo "$RESPONSE" | grep "HTTP_STATUS:" | cut -d: -f2)
RESPONSE_BODY=$(echo "$RESPONSE" | sed '/HTTP_STATUS:/d')

echo "📊 응답 결과:"
echo "   HTTP 상태: $HTTP_STATUS"

if [ "$HTTP_STATUS" -ge 200 ] && [ "$HTTP_STATUS" -lt 300 ]; then
    echo "   상태: ✅ 성공"
    echo ""
    echo "✨ 파일이 성공적으로 생성되었습니다!"
    echo "   경로: NotebookLM/API_테스트_노트.md"
    echo ""
    echo "💡 Obsidian을 열어서 파일을 확인하세요."
else
    echo "   상태: ❌ 실패"
    echo ""
    echo "⚠️  오류 발생:"
    echo "$RESPONSE_BODY"
    echo ""
    echo "문제 해결:"
    echo "1. Obsidian이 실행 중인지 확인"
    echo "2. Local REST API 플러그인이 활성화되어 있는지 확인"
    echo "3. API 키가 올바른지 확인"
fi

echo ""
echo "========================================="
