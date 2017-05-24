mysql -u root << 'EOF'

use glpi
truncate glpi_crontasklogs;
truncate glpi_documents;
truncate glpi_documents_items;
truncate glpi_events;
truncate glpi_logs;
truncate glpi_queuedmails;
truncate glpi_taskcategories;
truncate glpi_ticketfollowups;
truncate glpi_tickets;
truncate glpi_tickets_users;
truncate glpi_ticketsatisfactions;
truncate glpi_tickettasks;
truncate glpi_ticketvalidations;

EOF
