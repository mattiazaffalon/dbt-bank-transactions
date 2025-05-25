import xml.etree.ElementTree as ET
import pandas as pd
from datetime import datetime
import sys

def convert_xml_to_csv(input_path, output_path):
    ns = {"ns5": "urn:CBI:xsd:CBIDlyStmtReqLogMsg.00.01.02"}

    tree = ET.parse(input_path)
    root = tree.getroot()

    transactions = []
    for stmt in root.findall(".//ns5:Stmt", ns):
        for entry in stmt.findall("ns5:Ntry", ns):
            amount = float(entry.find("ns5:Amt", ns).text)
            sign = -1 if entry.find("ns5:CdtDbtInd", ns).text == "DBIT" else 1

            # Data contabile (BookgDt)
            bookg_elem = entry.find("ns5:BookgDt/ns5:Dt", ns)
            bookg_date = bookg_elem.text.split("+")[0] if bookg_elem is not None else None
            bookg_date = datetime.strptime(bookg_date, "%Y-%m-%d").date() if bookg_date else None

            # Data valuta (ValDt)
            val_elem = entry.find("ns5:ValDt/ns5:Dt", ns)
            val_date = val_elem.text.split("+")[0] if val_elem is not None else None
            val_date = datetime.strptime(val_date, "%Y-%m-%d").date() if val_date else None

            # Descrizione
            description_elem = entry.find(".//ns5:AddtlTxInf", ns)
            description = description_elem.text.strip() if description_elem is not None else ""

            transactions.append({
                "DataContabile": bookg_date,
                "DataValuta": val_date,
                "Importo": round(sign * amount, 2),
                "Descrizione": description
            })

    df = pd.DataFrame(transactions)
    df.to_csv(output_path, index=False)
    print(f"File CSV creato con successo: {output_path}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Uso: python convert_xml_to_csv.py <input_path.xml> <output_path.csv>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]

    convert_xml_to_csv(input_file, output_file)
