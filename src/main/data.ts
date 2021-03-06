/**
 * @file Data specifications of table, database and the whole system.
 */

class Table {
  name: string;
  col_name: string[];
  col_id: string[];
  r_lock_owner: number;
  w_lock_owner: number;
  types: ('number'|'string'|'date')[];
  data: any[][];
}

class Database {
  name: string;
  tables: {[tb_name: string]: Table};
}

class SystemData {
  dbs: {[db_name: string]: Database};
  cur_db: string;
  show_plan: boolean;
  panel_on: boolean;
  tx_cnt: number;
  debug: boolean;
  runningTxs: number[];
}

export { Table, Database, SystemData };