---
name: projekt-log
description: Prowadź dziennik projektu w Obsidian (vault ~/Documents/obsidian/natalia, folder projekty/). Use when starting new project work ("nowy projekt", "zacznij projekt"), after merges ("zaktualizuj stan projektu", "zaktualizuj dziennik"), to catch up missed PRs ("nadrób PR-y", "nadrabiamy PR"), or to check status ("na czym stoimy", "co robiliśmy", "co zostało do zrobienia", "co zrobione w projekcie"). Triggers also: obsidian projekt, dziennik PR, historia projektu.
---

# Projekt-log

Prowadź w Obsidian jeden folder na projekt: osobną notatkę na każdy PR oraz plik
`_stan.md` aktualizowany po każdym merge'u. Dzięki temu widać co robimy, co
robiliśmy i na czym stoimy.

## Gdzie

Vault: `~/Documents/obsidian/natalia/projekty/<nazwa-projektu>/`

Nazwa projektu = nazwa repo z `git remote get-url origin` (basename bez `.git`),
uproszczona do lowercase-hyphen. Jeśli użytkownik poda nazwę, użyj jej. Bez
remote → nazwa katalogu projektu.

## Struktura folderu

```text
projekty/<projekt>/
├── _stan.md                  ← status, do zrobienia, kronika
├── PR-12-pierwszy-opis.md    ← jeden plik na PR
└── PR-34-kolejny-opis.md
```

## Procedura

1. Ustal nazwę projektu (remote → basename bez `.git`, bez `.git` suffixu).
2. Sprawdź czy `~/Documents/obsidian/natalia/projekty/<projekt>/` istnieje.
3. Pobierz wszystkie zmergowane PR-y:
   - Repo na GitHubie: `gh pr list --state merged --limit 200 --json number,title,mergedAt,url,body` (dopisz `--author @me` przy repo zespołowym, jeśli użytkownik chce tylko swoje).
   - Bez GitHuba: `git log --merges --format='%h %ad %s' --date=short`; jeśli są
     squash-merge'e bez merge-commitów, użyj `git log --format=...` i grupuj po changelogu.
4. Dla każdego zmergowanego PR-a bez pliku stwórz notatkę (najsłabsze źródło
   danych: `gh pr view <nr> --json title,body,files,mergedAt,url`; czytaj diff
   wybranych plików tylko gdy opis nie wystarcza). Numeruj wg daty merge'u.
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
- Nigdy nie usuwaj istniejących notatek. `_stan.md` tylko uzupełniaj; sekcję
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

- `ls` na folderze projektu pokazuje `_stan.md` i plik na każdy zmergowany PR.
- Liczba plików PR = liczba zmergowanych PR-ów z listy w kroku 3 minus PR-y zależnościowe.
- `_stan.md` ma wypełnione wszystkie sekcje szablonu.
