-- Доп задание
USE petshop;
-- Используя JOIN-ы, выполните следующие операции:
-- 1 Вывести всех котиков по магазинам по id (условие соединения shops.id = cats.shops_id)
SELECT *
FROM cats c 
JOIN shops s
ON s.id = c.shops_id
ORDER BY shopname;


-- 2 Вывести магазин, в котором продается кот “Мурзик” (попробуйте выполнить 2 способами)
-- 2.1 
SELECT s.shopname, c.name
FROM cats c 
JOIN shops s
ON s.id = c.shops_id
WHERE c.name = 'Murzik';

-- 2.2 

SELECT shopname FROM shops
WHERE id = (SELECT shops_id FROM cats WHERE name = 'Murzik');

-- 3 Вывести магазины, в которых НЕ продаются коты “Мурзик” и “Zuza”

SELECT s.shopname, c.name, s.id, c.id
FROM shops s
LEFT JOIN cats c 
ON s.id = c.shops_id
WHERE c.name != 'Murzik' AND c.name != 'Zuza';

-- 4 Вывести название и цену для всех анализов, которые продавались 5 февраля 2020 и всю следующую неделю.
/*
Есть таблица анализов Analysis:
an_id — ID анализа;
an_name — название анализа;
an_cost — себестоимость анализа;
an_price — розничная цена анализа;
an_group — группа анализов.
Есть таблица групп анализов Groups:
gr_id — ID группы;
gr_name — название группы;
gr_temp — температурный режим хранения.
Есть таблица заказов Orders:
ord_id — ID заказа;
ord_datetime — дата и время заказа;
ord_an — ID анализа. */
SELECT ord_datetime, an_name, an_price, ord_an, an_id
FROM analysis
JOIN orders
ON ord_an = an_id
WHERE DATE(ord_datetime) BETWEEN '2020-02-05' AND '2020-02-12';


