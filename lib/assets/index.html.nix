{ grammars }:
let
  grammarSelect = grammar:
    let
      slug = "${grammar.language}/${grammar.author}";
      selected =
        if grammar.language == "elixir" then " selected=\"selected\"" else "";
    in ''<option value="${slug}"${selected}>${slug}</option>'';
  grammarSelects =
    builtins.concatStringsSep " " (builtins.map grammarSelect grammars);
in ''
  <html>
    <head>
      <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
      <meta charset="utf-8" />
      <title>TSPM 🌲</title>
      <link
        rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.45.0/codemirror.min.css"
      />
      <link
        rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/clusterize.js/0.18.0/clusterize.min.css"
      />
      <link
        rel="icon"
        type="image/png"
        href="https://tree-sitter.github.io/tree-sitter/assets/images/favicon-32x32.png"
        sizes="32x32"
      />
      <link
        rel="icon"
        type="image/png"
        href="https://tree-sitter.github.io/tree-sitter/assets/images/favicon-16x16.png"
        sizes="16x16"
      />
    </head>

    <body>
      <div id="playground-container" style="visibility: visible">
        <header>
          <div class="header-item">
            <bold></bold>
          </div>

          <div class="header-item">
            <label for="logging-checkbox">log</label>
            <input id="logging-checkbox" type="checkbox" />
          </div>

          <div class="header-item">
            <label for="query-checkbox">query</label>
            <input id="query-checkbox" type="checkbox" checked="checked" />
          </div>

          <div class="header-item">
            <label for="update-time">parse time: </label>
            <span id="update-time"></span>
          </div>

          <select id="language-select" style="display: none">${grammarSelects}</select>
        </header>

        <main>
          <div id="input-pane">
            <div id="code-container">
              <textarea id="code-input" style="display: none"></textarea>
            </div>
            <div id="query-container" style="">
              <textarea id="query-input" style="display: none"></textarea>
            </div>
          </div>

          <div id="output-container-scroll">
            <pre
              id="output-container"
              class="highlight"
              tabindex="0"
              style="counter-increment: clusterize-counter 0"
            ><div></div></pre>
          </div>
        </main>
      </div>

      <script
        src="https://code.jquery.com/jquery-3.3.1.min.js"
        crossorigin="anonymous"
      ></script>

      <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.45.0/codemirror.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/clusterize.js/0.18.0/clusterize.min.js"></script>

      <script>
        LANGUAGE_BASE_URL = "";
      </script>
      <script src="tree-sitter.js"></script>
      <script src="playground.js"></script>

      <style>
        body {
          margin: 0;
          padding: 0;
        }

        #playground-container {
          width: 100%;
          height: 100%;
          display: flex;
          flex-direction: column;
        }

        header {
          box-sizing: border-box;
          display: flex;
          padding: 20px;
          height: 60px;
          border-bottom: 1px solid #aaa;
        }

        main {
          flex: 1;
          position: relative;
        }

        #input-pane {
          position: absolute;
          top: 0;
          left: 0;
          bottom: 0;
          right: 50%;
          display: flex;
          flex-direction: column;
        }

        #code-container,
        #query-container {
          flex: 1;
          position: relative;
          overflow: hidden;
          border-right: 1px solid #aaa;
          border-bottom: 1px solid #aaa;
        }

        #output-container-scroll {
          position: absolute;
          top: 0;
          left: 50%;
          bottom: 0;
          right: 0;
        }

        .header-item {
          margin-right: 30px;
        }

        #playground-container .CodeMirror {
          position: absolute;
          top: 0;
          bottom: 0;
          left: 0;
          right: 0;
          height: 100%;
        }

        #output-container-scroll {
          flex: 1;
          padding: 0;
          overflow: auto;
        }

        #output-container {
          padding: 0 10px;
          margin: 0;
        }

        #logging-checkbox {
          vertical-align: middle;
        }

        .CodeMirror div.CodeMirror-cursor {
          border-left: 3px solid red;
        }

        a {
          text-decoration: none;
          color: #040404;
          padding: 2px;
        }

        a:hover {
          text-decoration: underline;
        }

        a.highlighted {
          background-color: #d9d9d9;
          color: red;
          border-radius: 3px;
          text-decoration: underline;
        }

        .query-error {
          text-decoration: underline red dashed;
          -webkit-text-decoration: underline red dashed;
        }
      </style>
    </body>
  </html>
''