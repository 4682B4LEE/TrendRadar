#!/bin/bash
# ═══════════════════════════════════════════════════════════════
#           TrendRadar Docker 部署脚本
#           用于火山引擎云服务器部署
# ═══════════════════════════════════════════════════════════════

set -e

echo "🚀 开始部署 TrendRadar..."

# 检查 Docker 和 Docker Compose 是否安装
if ! command -v docker &> /dev/null; then
    echo "❌ Docker 未安装，请先安装 Docker"
    echo "安装命令: curl -fsSL https://get.docker.com | sh"
    exit 1
fi

if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose 未安装，请先安装 Docker Compose"
    exit 1
fi

# 进入项目目录
cd "$(dirname "$0")"

# 创建必要的目录
echo "📁 创建必要的目录..."
mkdir -p output
mkdir -p config/custom/ai
mkdir -p config/custom/keyword

# 检查 .env 文件是否存在
if [ ! -f "docker/.env" ]; then
    echo "❌ docker/.env 文件不存在，请检查配置"
    exit 1
fi

# 检查 config 文件是否存在
if [ ! -f "config/config.yaml" ]; then
    echo "❌ config/config.yaml 文件不存在"
    exit 1
fi

# 拉取最新镜像
echo "📥 拉取最新 Docker 镜像..."
docker pull wantcat/trendradar:latest

# 启动服务
echo "🟢 启动 TrendRadar 服务..."
cd docker
if docker compose version &> /dev/null; then
    docker compose up -d
else
    docker-compose up -d
fi

echo ""
echo "✅ TrendRadar 部署完成！"
echo ""
echo "📊 查看日志: docker logs -f trendradar"
echo "🌐 访问报告: http://你的服务器IP:8080"
echo "⏱️  首次运行可能需要几分钟..."
echo ""
echo "📋 常用命令:"
echo "  查看状态: docker ps | grep trendradar"
echo "  查看日志: docker logs -f trendradar"
echo "  停止服务: cd docker && docker compose down"
echo "  重启服务: cd docker && docker compose restart"
echo "  手动执行: docker exec -it trendradar python manage.py run"
