# Guida di viaggio: Londra in famiglia (3–7 dicembre 2026)

Sito statico pubblicato con GitHub Pages dal branch `main`, cartella radice:
https://okpanic26.github.io/londra-2026/

Il proprietario scrive in italiano, spesso dal telefono. Rispondi in italiano, in modo semplice e breve.

## File

- `index.html`: tutta la guida in un unico file (HTML, CSS e JS inline). È la pagina pubblica.
- `guida-stampa.pdf`: versione A4 da stampare, generata da `index.html`.
- `strumenti/trascrivi-vocali.sh`: trascrive con Whisper le note vocali di un'esportazione di Telegram. Gira solo sul Mac del proprietario.

## Regole

1. **Il sito è pubblico.** Non inserire mai l'indirizzo dell'alloggio (resta "Londra ovest, zona 3"), numeri di telefono, codici di prenotazione, nomi completi o foto della famiglia.
2. **Pubblicazione.** GitHub Pages pubblica solo `main`. Se lavori su un altro branch, apri una pull request e chiedi al proprietario se unirla: finché non è in `main`, il sito non cambia.
3. **Messaggi di commit** in italiano, descrittivi ("Sposta il London Eye alle 15:00"): servono per riportare poi le stesse modifiche nella versione completa che sta sul Mac.
4. **Verifica.** Dopo ogni modifica controlla che la pagina si apra e che il JS sia valido, per esempio estraendo gli script e passandoli a `node --check`. Dopo il push, il sito si aggiorna in 1–2 minuti.
5. **Fatti e orari.** Curiosità, prezzi e orari vanno scritti solo se ne sei sicuro; altrimenti invita a verificarli sul sito ufficiale.

## PDF da stampare

Va rigenerato dopo ogni modifica dei contenuti, con le schede della miniguida aperte:

```bash
sed 's/<details>/<details open>/g' index.html > /tmp/stampa.html
chromium --headless --disable-gpu --no-pdf-header-footer --virtual-time-budget=8000 --print-to-pdf=guida-stampa.pdf file:///tmp/stampa.html
```

Al posto di `chromium` può servire `google-chrome` o, sul Mac, `"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"`. Se nessun browser headless è disponibile, non rigenerarlo e dillo al proprietario.

## Struttura di `index.html`

- **Colori e font** sono token CSS su `:root` (`--red`, `--district`, `--piccadilly`, `--hp`…), con le varianti per il tema scuro. Usa sempre i token, non colori fissi. Lo stile di stampa è in `@media print`.
- **Barra di navigazione** `nav.bar`: un link per sezione (`#giovedi` … `#lunedi`, `#miniguida`, `#trasporti`, …).
- **Giornate**: `<section id="venerdi">` con una lista `ol.tl`. Ogni tappa è:
  ```html
  <li class="stop"><div class="time">9:30</div><div class="what">
    <h3>Torre di Londra</h3>
    <p>Descrizione breve.</p>
    <div class="tags"><span class="tag book">Biglietti online</span></div>
    <a class="map" href="https://www.google.com/maps/search/?api=1&query=Tower+of+London" target="_blank" rel="noopener">Apri sulla mappa ↗</a></div></li>
  ```
  Etichette disponibili: `tag hp` (Harry Potter), `tag bond` (007 o giorno), `tag book` (da prenotare), `tag free` (gratis). Spostamenti in metro: `<div class="ride"><span class="line d">District</span> …</div>` (`line p` per la Piccadilly).
- **Miniguida**: `<section id="miniguida">`, una `article.mg` per luogo, con `id="mg-…"` e `data-keys="Testo del titolo della tappa"` (più chiavi separate da `|`). Uno script aggiunge da solo, sotto ogni tappa il cui `<h3>` contiene una chiave, il link "Curiosità e storie". Se cambi il titolo di una tappa, aggiorna `data-keys`. Dentro: due righe in `<p>`, poi `<details>` con `ul.mg-facts` (ogni `<li>` inizia con `<b>Tema</b>`) e `p.mg-links` con i link di approfondimento.
- **Da prenotare**: `ul.check` con checkbox; ogni `input` deve avere un `id` unico (le spunte si salvano nel browser con quell'id).

## Versione completa sul Mac

Sul Mac del proprietario esiste una versione completa non pubblica (con l'indirizzo, il diario di viaggio e la memoria finale), pubblicata come pagina privata su claude.ai. Da lì `index.html` viene rigenerato. Una sessione sul Mac, prima di rigenerare `index.html`, deve fare `git pull` e riportare nella versione completa le modifiche fatte nel frattempo su GitHub, per non cancellarle.
