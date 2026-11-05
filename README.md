# 🇦🇿 Baku Doner & Burger House — End-to-End Analytics Project

Комплексный аналитический проект сети ресторанов быстрого питания **"Baku Doner & Burger House"** (Филиалы: *Nərimanov, 28 May, Neftçilər, Xırdalan, Masazır*).

---

## 📌 Архитектура Проекта

```text
baku-fastfood-analytics/
├── data/
│   └── baku_fastfood_sales.csv        # Первичный датасет (CSV)
├── sql/
│   └── baku_fastfood_analytics.sql   # DDL, DML и бизнес-запросы (PostgreSQL 17)
├── excel/
│   └── baku_fastfood_analysis.xlsx   # Анализ данных в Excel
├── power_bi/
│   └── baku_fastfood_dashboard.pbix   # Интерактивный дашборд Power BI
└── README.md
🛠 Стек Технологий
PostgreSQL / pgAdmin 4: Схема БД, DDL/DML, JOINs, CTE, оконные функции (DENSE_RANK).

Excel: Обработка данных и сводные таблицы.

Power BI Desktop: Визуализация KPI и анализ продаж.

📊 Ключевые Выводы (Insights)
Доставка в Хырдалане и Масазыре: Формирует свыше 75% выручки пригородных филиалов и максимальный средний чек.

Трафик в Нариманов: Офисный пик заказов в обеденное время (12:00–14:00) с преобладанием безналичных карт (BirBank / LeoCard).