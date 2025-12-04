#!/bin/bash
# Команды для работы с лидами

case $1 in
  "stats")
    docker-compose exec app rails runner "
      puts '📊 Статистика лидов:'
      puts 'Всего: #{Lead.count}'
      puts 'Новые: #{Lead.where(status: \"Новая\").count}'
      puts 'В работе: #{Lead.where(status: \"В работе\").count}'
      puts 'Завершены: #{Lead.where(status: \"Завершена\").count}'
    "
    ;;
  "list")
    docker-compose exec app rails runner "
      puts '📋 Последние 10 лидов:'
      Lead.order(created_at: :desc).limit(10).each do |lead|
        puts \"#{lead.id}. #{lead.name} (#{lead.email}) - #{lead.status}\"
      end
    "
    ;;
  "add")
    if [ -z "$2" ]; then
      echo "Использование: ./leads_commands.sh add \"Имя\" email@test.com +79991234567"
    else
      docker-compose exec app rails runner "
        lead = Lead.new(
          name: '$2',
          email: '${3:-test@example.com}',
          phone: '${4:-+79991234567}',
          status: 'Новая'
        )
        if lead.save
          puts '✅ Лид создан: #{lead.name}'
        else
          puts '❌ Ошибка: #{lead.errors.full_messages}'
        end
      "
    fi
    ;;
  "export")
    docker-compose exec app rails runner "
      require 'csv'
      CSV.open('/tmp/leads_export.csv', 'w') do |csv|
        csv << ['ID', 'Имя', 'Email', 'Телефон', 'Статус', 'Создан']
        Lead.all.each do |lead|
          csv << [lead.id, lead.name, lead.email, lead.phone, lead.status, lead.created_at]
        end
      end
      puts '✅ Экспортировано #{Lead.count} лидов в /tmp/leads_export.csv'
    "
    docker-compose cp app:/tmp/leads_export.csv ./leads_export_$(date +%Y%m%d).csv
    echo "📥 Файл сохранён как ./leads_export_$(date +%Y%m%d).csv"
    ;;
  *)
    echo "Команды:"
    echo "  stats  - показать статистику"
    echo "  list   - показать последние лиды"
    echo "  add    - добавить лид (./leads_commands.sh add \"Имя\" email phone)"
    echo "  export - экспортировать лиды в CSV"
    ;;
esac
