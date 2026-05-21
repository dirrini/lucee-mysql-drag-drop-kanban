<cftry>
    <!--- Queries para o Kanban --->
    <cfquery name="kanbanQ" datasource="mydb">
      SELECT * FROM kanban ORDER BY id ASC LIMIT 1
    </cfquery>

    <cfif kanbanQ.recordCount>
      <cfquery name="listsQ" datasource="mydb">
        SELECT * FROM kanban_list WHERE kanban_id = <cfqueryparam value="#kanbanQ.id#" cfsqltype="cf_sql_integer" /> ORDER BY list_order ASC
      </cfquery>
    <cfelse>
      <cfset listsQ = {recordCount=0} />
    </cfif>

    <html>
    <!DOCTYPE html>
    <html data-theme="cupcake"> <!-- Altere para 'light', 'nord', ou 'cupcake' se preferir -->
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Kanban Board 1.0</title>
        <!-- Google Fonts Import -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:ital,wght@0,200..800;1,200..800&display=swap" rel="stylesheet">

        <!-- Tailwind CSS Core Engine -->
        <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>

        <!-- daisyUI Component Plugin Styles -->
        <link href="https://cdn.jsdelivr.net/npm/daisyui@5.0.0-beta.8/daisyui.css" rel="stylesheet" type="text/css" />

        <!-- SortableJS -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Sortable/1.15.2/Sortable.min.js"></script>
        <style type="text/tailwindcss">
            @theme {
                /* This overrides the default font-sans family sitewide across all classes */
                --font-sans: 'Plus Jakarta Sans', sans-serif;
            }
        </style>
    </head>
    <body class="bg-base-300 min-h-screen p-4 text-base-content font-sans">
        <h1 class="text-xl mb-4 font-bold tracking-wider uppercase bg-linear-to-r from-primary to-secondary bg-clip-text">
            Kanban Board 1.0
        </h1>
        <!-- Main Kanban Grid Container -->
        <div class="flex gap-6 overflow-x-auto pb-4 items-start">
            <cfset months = 'Jan,Fev,Mar,Abr,Mai,Jun,Jul,Ago,Set,Out,Nov,Dez'>
            
            <cfif listsQ.recordCount EQ 0>
                <div class="alert alert-warning max-w-md shadow-md">
                    <span>Sem kanban configurado no sistema.</span>
                </div>
            <cfelse>
                <cfoutput query="listsQ">
                    <!-- Column Container -->
                    <div class="bg-base-100 p-4 rounded-box w-72 shrink-0 shadow-xs border border-base-200">
                        
                        <!-- Column Header Status -->
                        <div class="flex justify-between items-center mb-4 px-1">
                            <h3 class="font-bold text-sm tracking-wide uppercase opacity-75">
                                #htmlEditFormat(name)#
                            </h3>
                        </div>

                        <!-- Sortable Target Container -->
                        <div id="lista-#id#" class="kanban-list-target space-y-3 min-h-[450px] rounded-lg p-1 bg-base-200/40">
                            
                            <cfquery name="cardsForList" datasource="mydb">
                                SELECT kc.*, kcl.card_order, a.name AS author_name, a.avatar AS author_avatar
                                FROM kanban_card_list kcl
                                JOIN kanban_card kc ON kcl.kanban_card_id = kc.id
                                LEFT JOIN author a ON kc.author_id = a.id
                                WHERE kcl.kanban_list_id = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer" />
                                ORDER BY kcl.card_order ASC
                            </cfquery>

                            <cfif cardsForList.recordCount>
                                <cfloop query="cardsForList">
                                    <!-- Individual Kanban Card Item -->
                                    <div data-id="#id#" class="card bg-base-100 shadow-sm border border-base-300 hover:border-primary/40 cursor-grab active:cursor-grabbing transition-all duration-150">
                                        <div class="card-body !p-3 gap-2 bg-base-200 rounded-lg">
                                            
                                            <!-- Card Layout Header Block -->
                                            <div class="flex justify-between items-start gap-3">
                                                <span class="font-semibold text-sm leading-snug break-words flex-1 text-base-content/90">
                                                    #htmlEditFormat(title)#
                                                </span>
                                                
                                                <!-- DaisyUI Avatar Circular Mask Wrapper -->
                                                <div class="avatar placeholder shrink-0" title="#htmlEditFormat(author_name)#">
                                                    <div class="bg-primary text-primary-content rounded-full w-6 h-6 text-[11px] font-bold">
                                                        <span>
                                                            <cfif Len(author_name)>
                                                                #UCase(Left(author_name,1))#
                                                            <cfelse>
                                                                ?
                                                            </cfif>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Card Bottom Metadata Information -->
                                            <div class="flex items-center gap-1.5 text-[11px] opacity-60">
                                                <span>📅</span>
                                                <span>
                                                    <cfif len(due_date)>
                                                        <cfset day = Day(due_date) />
                                                        <cfset mon = Month(due_date) />
                                                        <cfset year = Year(due_date) />
                                                        #day# de #ListGetAt(months,mon)#, #year#
                                                    <cfelse>
                                                        Sem prazo
                                                    </cfif>
                                                </span>
                                            </div>

                                        </div>
                                    </div>
                                </cfloop>
                            </cfif>

                        </div>
                    </div>
                </cfoutput>
            </cfif>
        </div>

        <!-- Script Layer Hooking SortableJS Across Dynamic Target IDs -->
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                // Find all list containers rendered by Lucee
                const lists = document.querySelectorAll('.kanban-list-target');
                
                lists.forEach(list => {
                    Sortable.create(list, {
                        group: 'kanban',
                        animation: 180,
                        ghostClass: 'opacity-25',       // Replaces your old blue background ghost styling
                        chosenClass: 'scale-[1.015]',    // Subtle feedback when picking up card
                        dragClass: 'shadow-xl',          // Clean hovering drop-shadow
                        
                        onEnd: function (evt) {
                            const cardId = evt.item.dataset.id;
                            const targetListId = evt.to.id.replace('lista-', ''); // Extracts base ID number
                            const orderArray = this.toArray(); // Captures full target column layout state
                            
                            console.log(`Card ID: ${cardId} moved to Column: ${targetListId}`);
                            console.log("New order mapping array:", orderArray);

                            // Your fetch() integration goes directly right here...
                        }
                    });
                });
            });
        </script>
    </body>
    <script>
        // Opções compartilhadas entre as listas
        const sortableOptions = {
            group: 'kanban', // Permite mover entre listas com o mesmo nome de grupo
            animation: 150,  // Milissegundos da animação (fica bem fluido)
            ghostClass: 'ghost', // Classe aplicada ao card original enquanto arrastamos
            
            // Evento disparado quando o item é solto
            onEnd: function (evt) {
                const itemEl = evt.item;  // O elemento HTML arrastado
                const targetCol = evt.to.id; // ID da coluna de destino
                const itemId = itemEl.getAttribute('data-id'); // ID que veio do seu banco
                const position = evt.newIndex; // Nova posição dentro da coluna
                
                console.log(`Card ${itemId} movido para ${targetCol} na posição ${position}`);

                // EXERCÍCIO DE PRÓXIMO PASSO:
                // Chamar um fetch() para o seu Lucee avisando a mudança no MySQL:
                /*
                fetch('/api/update_status.cfm', {
                method: 'POST',
                body: JSON.stringify({ id: itemId, status: targetCol, position: position })
                });
                */
            }
        };
        // Inicializa as colunas
        <cfoutput query="listsQ">
            Sortable.create(document.getElementById('lista-#id#'), sortableOptions);
        </cfoutput>
    </script>
    </html>

    <cfcatch type="any">
        <h1>ERRO:</h1>
        <p><cfoutput>#cfcatch.type#: #cfcatch.message#</cfoutput></p>
        <p><cfoutput>#cfcatch.detail#</cfoutput></p>
        <cfdump var="#cfcatch#">
    </cfcatch>
</cftry>
