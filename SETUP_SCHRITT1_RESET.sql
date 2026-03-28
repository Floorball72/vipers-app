-- ============================================================
-- SCHRITT 1: Alles löschen
-- Zuerst NUR dieses Script ausführen, dann SCHRITT 2
-- ============================================================

-- Abhängige Tabellen zuerst
drop table if exists inventar_ausleihen     cascade;
drop table if exists inventar               cascade;
drop table if exists sponsor_leistungen     cascade;
drop table if exists sponsoren              cascade;
drop table if exists anwesenheit            cascade;
drop table if exists news                   cascade;
drop table if exists mitgliedsausweise      cascade;
drop table if exists videoanalysen          cascade;
drop table if exists trainingseinheiten     cascade;
drop table if exists scorer                 cascade;
drop table if exists social_posts           cascade;
drop table if exists finanzen               cascade;
drop table if exists events                 cascade;
drop table if exists games                  cascade;
drop table if exists players                cascade;
drop table if exists user_club_memberships  cascade;
drop table if exists user_profiles          cascade;
drop table if exists teams                  cascade;
drop table if exists clubs                  cascade;

select 'Reset abgeschlossen — jetzt SCHRITT 2 ausführen' as status;
