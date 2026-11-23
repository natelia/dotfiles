---
name: projekt-log
description: Prowadź dziennik projektu w Obsidian (vault ~/Documents/obsidian/natalia, folder projekty/). Osobne notatki tylko dla 5 ostatnich zmergowanych PR-ów i każdego nowego; starsze konsoliduj do _archiwum-pr.md. Use when starting new project work ("nowy projekt", "zacznij projekt"), after merges ("zaktualizuj stan projektu", "zaktualizuj dziennik"), to catch up missed PRs ("nadrób PR-y", "nadrabiamy PR"), to consolidate old PR notes ("zaoraj PR-y", "archiwum PR", "skonsoliduj notatki"), or to check status ("na czym stoimy", "co robiliśmy", "co zostało do zrobienia", "co zrobione w projekcie"). Triggers also: obsidian projekt, dziennik PR, historia projektu.
---

# Projekt-log

Prowadź w Obsidian jeden folder na projekt: `_stan.md` aktualizowany po każdym
merge'u, osobne notatki dla 5 ostatnich zmergowanych PR-ów i każdego nowego,
oraz `_archiwum-pr.md` z kompaktowymi wpisami starszych PR-ów. Dzięki temu
widać co robimy, co robiliśmy i na czym stoimy, bez lawiny plików.

## Gdzie

Vault: `~/Documents/obsidian/natalia/projekty/<nazwa-projektu>/`

Nazwa projektu = nazwa repo z `git remote get-url origin` (basename bez `.git`),
uproszczona do lowercase-hyphen. Jeśli użytkownik poda nazwę, użyj jej. Bez
remote → nazwa katalogu projektu.

## Struktura folderu

```text
projekty/<projekt>/
├── _stan.md                  ← status, do zrobienia, kronika
├── _archiwum-pr.md           ← starsze PR-y, jeden wpis na PR
├── PR-12-pierwszy-opis.md    ← jeden plik na PR (5 ostatnich + nowe)
└── PR-34-kolejny-opis.md
```

## Procedura

1. Ustal nazwę projektu (remote → basename bez `.git`, bez `.git` suffixu).
2. Sprawdź czy `~/Documents/obsidian/natalia/projekty/<projekt>/` istnieje.
3. Pobierz wszystkie zmergowane PR-y:
   - Repo na GitHubie: `gh pr list --state merged --limit 200 --json number,title,mergedAt,url,body` (dopisz `--author @me` przy repo zespołowym, jeśli użytkownik chce tylko swoje).
   - Bez GitHuba: `git log --merges --format='%h %ad %s' --date=short`; jeśli są
     squash-merge'e bez merge-commitów, użyj `git log --format=...` i grupuj po changelogu.
4. Podziel zmergowane PR-y wg daty merge'u:
   - Ostatnie 5 — osobne notatki wg szablonu niżej (najsłabsze źródło danych:
     `gh pr view <nr> --json title,body,files,mergedAt,url`; czytaj diff
     wybranych plików tylko gdy opis nie wystarcza).
   - Wszystkie starsze — kompaktowe wpisy w `_archiwum-pr.md` (format niżej),
     bez osobnych plików.
5. Utwórz lub zaktualizuj `_stan.md` (szablon niżej).
6. Wypisz listę utworzonych/zaktualizowanych plików.

## Szablon `PR-<numer>-<slug>.md`

```markdown
# PR #<numer> — <tytuł>

- Link: <url>
- Zmergowany: <YYYY-MM-DD>
- Ticket: <jeśli jest>

## Co

<co konkretnie zmienione — pliki, obszary>

## Po co

<biznesowy/techniczny powód, kontekst, link do dyskusji>

## Jak

<podejście, kluczowe decyzje, co było trudne>

## Wnioski / następne kroki

<co z tego wynika; każde "do zrobienia" przenieś też do _stan.md>
```

Slug: lowercase, same ASCII litery/cyfry/myślniki, do ~4 słów. PR bez numeru:
`PR-<shortsha>-<slug>.md`.

## Szablon `_archiwum-pr.md`

```markdown
# Archiwum PR-ów — <projekt>

Starsze PR-y skonsolidowane <YYYY-MM-DD>. Szczegóły pod linkiem.

- <YYYY-MM-DD> — [PR #<nr>: <tytuł>](<url>) — <jedna linia "Co">
```

Kolejność chronologiczna od najstarszego. Wpis = data, numer, tytuł, link,
maksymalnie jedna linia opisu. Jeśli folder istnieje i ma więcej niż 5 plików
PR, przepisz nadmiar do archiwum i skasuj te pliki. Nowy backfill dopisuje
wpisy na końcu (przed wpisami nowszymi niż 5 ostatnich PR-ów).

## Szablon `_stan.md`

```markdown
# <Projekt>

- Repo: <url>
- Stack: <skrót>
- Notatka utworzona: <YYYY-MM-DD>
- Ostatnia aktualizacja: <YYYY-MM-DD>

## Na czym stoimy

<2–4 zdania: cel, aktualny etap, najbliższy krok>

## Do zrobienia

- [ ] <zadanie> (źródło: PR #<nr> / ticket / rozmowa)

## Kronika

<najnowsze na górze, jedno zdanie na PR>
- <YYYY-MM-DD> — PR #<nr>: <tytuł>
```

## Zasady

- Notatki po polsku.
- Osobne pliki PR tylko dla 5 ostatnich zmergowanych PR-ów i każdego nowego
  merge'u. Po nowym merge'u, jeśli plików jest więcej niż 5, najstarszy
  przenieś do `_archiwum-pr.md` (wpis + link) i skasuj jego plik.
- Nie kasuj notatek PR bez śladu — najpierw wpis w `_archiwum-pr.md`, potem
  plik. `_stan.md` tylko uzupełniaj; sekcję
  "Do zrobienia" aktualizuj, zrobione pozycje oznaczaj `[x]` zamiast kasować.
- "Do zrobienia" czerp z: ciał PR-ów (sekcje TODO/następne kroki), review
  komentarzy (`gh pr view <nr> --comments`), otwartych issue/PR, notatek
  użytkownika. Nie wymyślaj zadań, których nikt nie zapisał.
- Po każdym nowym merge'u (użytkownik mówi "zmergowałam/zmergował PR"): stwórz
  notatkę PR i dopisz do "Kronika" + "Do zrobienia" + "Ostatnia aktualizacja".
- PR-y zależnościowe (dependabot/renovate, tytuły `chore(deps)`): bez osobnego pliku,
  jedna linia w Kronice.
- Repo zespołowe: domyślnie wszystkie PR-y zmergowane przez użytkownika
  (`gh pr list --state merged --author @me`), chyba że użytkownik każe wszystkie.
- Obsidian to zwykły markdown — bez pluginowej składni poza checkboxami i linkami.

## Weryfikacja

- `ls` na folderze projektu pokazuje `_stan.md` i co najwyżej 5 osobnych
  plików PR (plus ewentualne PR-y zależnościowe — te nigdy nie mają plików).
- Każdy PR starszy niż 5 ostatnich istnieje wyłącznie jako wpis w
  `_archiwum-pr.md`, z linkiem.
- Liczba wpisów w archiwum + liczba plików PR = liczba zmergowanych PR-ów
  z listy w kroku 3 minus PR-y zależnościowe.
- `_stan.md` ma wypełnione wszystkie sekcje szablonu.
