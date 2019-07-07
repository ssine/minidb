import * as fs from 'fs'

class Log {
    timestamp: string;
    operation: string;
    transactionID: number;

    constructor(operation: string, txID: number) {
        this.timestamp = (new Date()).toLocaleString();
        this.operation = operation;
        this.transactionID = txID;
    }
}

class InsertLog extends Log {
    database: string;
    table: string;
    value: any[];

    constructor(txID: number, database: string, table: string, value: any[]) {
        super('INSERT', txID);
        this.database = database;
        this.table = table;
        this.value = value;
    }
}

class DeleteLog extends Log {
    database: string;
    table: string;
    row: number;
    value: any[];

    constructor(txID: number, database: string, table: string, row:number, value: any[]) {
        super('DELETE', txID);
        this.database = database;
        this.table = table;
        this.row = row;
        this.value = value;
    }
}

class UpdateLog extends Log {
    database: string;
    table: string;
    row: number;
    column: string;
    updateFrom: any;
    updateTo: any;

    constructor(txID:number, database: string, table: string, row:number, column: string, updateFrom: any, updateTo: any) {
        super('UPDATE', txID);
        this.database = database;
        this.table = table;
        this.row = row;
        this.column = column;
        this.updateFrom = updateFrom;
        this.updateTo = updateTo;
    }
}

class BeginTxLog extends Log {
    constructor(txID: number) {
        super('BEGIN TRANSACTION', txID);
    }
}

class CommitTxLog extends Log {
    constructor(txID: number) {
        super('COMMIT TRANSACTION', txID);
    }
}

class CheckPoint {
    timestamp: string;
    operation: string;
    runningTransactions: number[];

    constructor(runningTxs: number[]) {
        this.timestamp = (new Date()).toLocaleString();
        this.operation = 'CHECKPOINT';
        this.runningTransactions = runningTxs;
    }
}

let logPath = './log.json';

function writeLog(log: Log | CheckPoint) {
    fs.appendFileSync(logPath, JSON.stringify(log) + '\n');
}

export {
    InsertLog,
    DeleteLog,
    UpdateLog,
    BeginTxLog,
    CommitTxLog,
    CheckPoint,
    writeLog
}