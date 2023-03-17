# CVTool
CVTool je nástroj, který byl speciálně vyvinut pro práci s CV projektem. Jeho hlavní funkcí je komunikace s CV webem pomocí Rest API, který poskytuje mnoho endpointů, které lze přistupovat pomocí GET a POST metod.

Ale CVTool také nabízí další užitečné funkce pro vývojáře. Například umožňuje generovat security token, který je potřeba při implementaci CV projektu. Dále také umožňuje snadno stáhnout všechny potřebné informace z databáze, jako jsou například články a projekty, a exportovat je do formátu JSON pro zálohování CV webu. Tyto exportované JSON soubory lze poslat zpátky na CV web nebo použít k vytvoření vlastního souboru s obsahem pro daný endpoint a odeslat jej.

## Instalace
Pro instalaci nástroje CVTool je nutné mít nainstalovaný jazyk Ruby. Nástroj lze nainstalovat pomocí ekosystému Ruby *gem*.

Stačí použít následující příkaz:
```bash
gem install cv-tool
```

Tento příkaz automaticky nainstaluje nejnovější verzi nástroje CVTool do vašeho systému a zajistí jeho správné nastavení pro použití.

## Použití
Aplikace nabízí následující funkce,
které můžete spustit s příslušnými argumenty:

- **-h, --help**
    > Show help
- **-v, --version**
    > Show version
- **-dp, --deactive-print**
    > Disables the printing process.

- **-ra, --rest-api**
    > Rest API for get and post operations
    > (additional setting options).
    - **-ep ROUTE, --endpoint ROUTE**
        > Defining an endpoint to use in order
        > to access a specific function.
    - **-epl, --endpoints-list**
        > A list of endpoints is printed.
    - **-reb PATH, --request-body PATH**
        > The information that must be sent
        > as *request.body* via a json file.
        > (The location to the *.json* file must be
        > entered if this option is chosen;
        > else, the data must be manually entered
        > via the terminal input.)
    - **-gdb PATH, --generate-db PATH**
        > It creates *json* files for Projects and
        > Articles in the defined path (it obtains
        > the relevant data from the Rest API, which
        > is then sorted and saved).

- **-gt LENG, --generate-token LENG**
    > To secure API server access, this function
    > generates a token with a specified length
    > (manual entry of the token into the ENV
    > is required).
    > The default: 40 length
- **-sa URL, --set-api URL**
    > Sets the API server's primary URL.
    > The default: http://localhost:8080/api/v1
- **-ss BOOL, --set-ssl BOOL**
    > Sets the SSL encryption protocol.
    > The default: false

### 1 Rest API
Pro správnou funkčnost REST API je nutné nastavit správné hodnoty pro argumenty --set-api a --set-ssl. Po úspěšném nastavení lze přistupovat k REST API pomocí argumentu --rest-api. Tento argument otevírá další možnosti pro volbu požadované funkce, přičemž základem je vyplnění argumentu --endpoint s danou routou.

Pro lepší orientaci v dostupných endpoints je k dispozici argument --endpoints-list, který umožňuje vytisknout seznam rout.

Níže uvádíme seznam dostupných endpoints:
- *Article:*
    - **get/articles**
    - **post/article/add**
    - **post/article/free**
    - **post/article/update**

- *Project:*
    - **get/projects**
    - **post/project/add**
    - **post/project/free**
    - **post/project/update**

- *Profile:*
    - **get/profiles**
    - **post/profile/add**
    - **post/profile/free**
    - **post/profile/update**

- *Table:*
    - **post/tables/reset**

### 1.1 GET
Pro získání potřebných informací pomocí metody GET je nutné použít zvolený endpoint, který začíná s get/ v routě. Pokud potřebujeme získat informace o článcích, můžeme použít následující příkaz v terminálu:

```bash
cvtool -ra -ep get/articles
```

### 1.2 POST
Pro použití metody POST se přistupuje pomocí zvoleného endpointu, která začíná *post/* v routě. Pokud potřebujete vytvořit nový projekt, můžete použít následující příkaz, který vás následně bude vyzývat k zadání dalších informací:

```text
cvtool -ra -ep post/project/add
...
author_id: 1
name: Sandbox 
category: Test 
content (a file's path): Content is this text, so I'm not writing the absolute path to the json file for content here.
...
```

### 1.2a Request Body
Pro všechny endpointy začínající s "post/" v routě existuje možnost použít argument "--request-body", kam můžete zadat cestu k JSON souboru s klíči pro daný endpoint.

Pokud chcete vytvořit nový článek pro již existující projekt, můžete postupovat následovně:
 
1. Zjistěte ID projektu pomocí příkazu:
    ```bash
    cvtool -ra -ep get/projects
    ```
2. Vytvořte JSON soubor s názvem "article_1.json", který bude obsahovat následující klíče pro článek:
    ```json
    // article_1.json
    {
        "author_id": 1,
        "project_id": 1,
        "name": "Article for Sandbox",
        "description": "Here will be a description of the article.",
        "url": "https://github.com/<article_name>.md"
    }
    ```
3. Následně můžete použít příkaz níže a jako argument "--request-body" přidat vytvořený soubor "article_1.json". Poté se spustí příkaz a vše se automaticky provede bez nutnosti vyplňovat další informace o projektu do terminálu.

    Ukázkový příkaz:
    ```bash
    cvtool -ra -ep post/project/add --request-body /home/filip/artcile_1.json 
    ```

### 1.2a1 JSON Templates
Zde naleznete více šablon pro json soubory a kompletní seznam na následujícím odkazu:

- [JSON Templates](/docs/json_templates.md)

> ### Info
> Endpoint **post/tables/reset** nemá JSON šablonu, protože není třeba připojovat žádné informace do request body. Tento endpoint slouží k resetování tabulek a nepotřebuje žádná data pro své provedení.

### 1.2b Bezpečnostní Token
Pro využití metody POST v aplikaci CVTool je nezbytné mít vložen bezpečnostní token do prostředí UNIX. Pokud takový token v prostředí nemáte, metoda POST se neprovede.

Pro vložení bezpečnostního tokenu postupujte následovně:

1. Otevřete soubor *.bashrc* v domovském adresáři příkazem: 
    ```bash
    nano ~/.bashrc
    ```
2. Na konec souboru přidejte řádek s exportem pro proměnnou **CV_TOKEN**, kde hodnotou bude váš bezpečnostní token.

    Například:
    ```txt
    export CV_TOKEN="iq9ZLdFB6NI2PlUBSy1gMXAwVEIJ1OTedarIaRDQ"
    ```
3. Uložte soubor a tím vložíte bezpečnostní token do prostředí UNIX.

### 1.3 Generování DB
Zálohování databáze CV webu na lokální disk je nástroj umožňující stáhnout všechny potřebné informace pro články a projekty. Příkaz --generate-db vybere pouze důležité informace a uloží je jednotlivě do JSON souborů, a to článek po článku a projekt po projektu. Chcete-li zálohovat databázi, zadejte cestu k cílové složce jako argument příkazu.

Postup pro generování DB je následující:

1. Vygenerujte DB do konkrétní složky pomocí následujícího příkazu:

    ```bash
    cvtool -ra --generate-db ~/Desktop/cv_db
    ```

Po dokončení procesu vám program vypíše informace o tom, jaké soubory byly vygenerovány. Všechny články a projekty jsou uloženy ve složce "~/Desktop/cv_db".

Struktura této složky by měla vypadat následovně:

```txt
~/Desktop/cv_db
├── articles
│   └── article_1.json
└── projects
    └── project_1.json
```

### 2 Generování tokenu
K vygenerování nového bezpečnostního tokenu můžete použít příkaz "--generate-token", ke kterému můžete definovat délku tokenu. Pokud délku tokenu nedodefinujete, program automaticky vygeneruje token o délce 40 znaků.

Zde je příklad příkazu pro generování bezpečnostního tokenu:

```bash
cvtool --generate-token
```

Vygenerovaný bezpečnostní token uložte do prostředí UNIX. Pokud nevíte, jak bezpečnostní token do prostředí uložit, přečtěte si tento úryvek:

- [1.2b Bezpečnostní Token](#12b-bezpečnostní-token)

### 3 Nastavení API
Pro úplnou manipulaci s API v rámci CVTool programu je nutné nastavit URL adresu API. K tomu slouží atribut "--set-api", kterým lze nastavit požadovanou adresu. Výchozí adresa, která je nastavena pro lokální server používaný v rámci vývojového prostředí CV projektu, je "http://localhost:8080/api/v1".

Pokud chceme změnit URL adresu API, můžeme použít následující příkaz:

```bash
cvtool --set-api https://cvfv.fly.dev
```
Tímto příkazem lze změnit URL adresu na požadovanou.

### 4 Nastavení SSL
SSL (Secure Sockets Layer) je technologie, která zajišťuje šifrovanou komunikaci mezi webovým serverem a klientem a poskytuje bezpečnost při přenosu citlivých dat. Pokud chceme aktivovat SSL, je potřeba použít atribut "--set-ssl" a nastavit mu hodnotu "true". Výchozí hodnota je "false", protože lokální server pro testování obvykle nepotřebuje tuto bezpečnostní funkci.

Pro aktivaci SSL použijte následující příkaz:

```bash
cvtool --set-ssl true
```

> ### Info
> Pokud máte již nahraný CV web například v rámci služby fly.io, je třeba aktivovat SSL.

## Struktura projektu
Tento projekt je napsán v programovacím jazyce Ruby. Všechny skripty používají pouze modul a není zde použit objekt třídy.

Projekt je rozdělen do následujících složek:

```txt
.
├── app
├── bin
├── lib
└── test
```

Popis složek:

- **app**: Složka obsahuje skripty pro CLI aplikaci. Zde najdete skripty pro zacházení s terminálem. Níže jsou uvedeny skripty, které se používají:

    - *arguments.rb*: Obsahuje veškeré argumenty pro nástroj CVTool.
    - *configuration.rb*: Konfigurace pro nástroj CVTool, ukládá potřebné informace, které se nemusí zadávat jako argumenty.
    - *inputs.rb*: Zahrnuje zpracování vstupů z terminálu, když terminál požaduje vstup potřebný pro odeslání požadavku pro API.
    - *main.rb*: Hlavní skript, který se spouští pokaždé, když se aplikace spustí.
    - *signals.rb*: Obsahuje všechny potřebné signály UNIX, které nástroj CVTool přijímá.

- **bin**: Obsahuje spustitelné soubory, které jsou:

    - *build*: Skript napsaný v Ruby, který vytváří balíček gem a nahrává jej na Ruby Gem.
    - *cvtool*: Spouští hlavní skript main.rb.
    - *test*: Skript napsaný v bash, který provádí určité testy, které jsou rozděleny podle čísel. Pokud chcete spustit test s číslem jedna, napíšete za spustitelný soubor 1.

- **lib**: Obsahuje veškerou logiku aplikace.
- **test**: Obsahuje potřebné soubory pro provádění testů.

## Závislosti
Tento CVTool nástroj lze spustit bez instalace dalších gem balíčků. Jedinou požadovanou závislostí je zprovozněný CV web, buď lokálně nebo veřejně.

Zde je odkaz na CV repozitář:
- [cv-v](https://github.com/filipvrba/cv-v)

## Články
Zde najdete několik článků, které poskytují další informace o projektu CVTool:

- [CV](https://cvfv.fly.dev/projects/cv)

## Ukázky
Zde naleznete několik obrázků, které ilustrují funkčnost CVTool nástroje.

![cvtool_terminal_01](/docs/public/cvtool_terminal_01.png)

(pic. 1) A terminal window displaying the cvtool help tool in execution.

![cvtool_terminal_03](/docs/public/cvtool_terminal_03.png)

(pic. 2) Nástroj generuje nový bezpečnostní token.

![cvtool_terminal_04](/docs/public/cvtool_terminal_04.png)

(pic. 3) Obrázek ukazuje nástroj, který generuje databázi z testovacího CV API a ukládá ji na lokální disk do zvolené složky.

![cvtool_terminal_05](/docs/public/cvtool_terminal_05.png)

(pic. 4) Nástroj umožňuje vytváření nových článků a interaktivně dotazuje uživatele na potřebné informace prostřednictvím terminálu.

![cvtool_terminal_06](/docs/public/cvtool_terminal_06.png)

(pic. 5) Dva otevřené terminálové okna. V levém okně je dotaz na informace o projektu a v pravém okně je požadavek na změnu projektu pomocí příkazu.

## Licence
Tento projekt je opensource pod licencí MIT, který naprogramoval [Filip Vrba](https://github.com/filipvrba) opensource vývojář.
