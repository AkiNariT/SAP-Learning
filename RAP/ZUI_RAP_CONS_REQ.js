@Metadata.layer: #CORE
@UI: {
  headerInfo: {
    typeName: 'Consumable Request',
    typeNamePlural: 'Consumable Requests',
    title: {
      type: #STANDARD,
      value: 'ItemText'
    },
    description: {
      value: 'Status'
    }
  }
}
annotate entity ZC_RAP_CONS_REQ with
{
  @UI.facet: [
    {
      id: 'General',
      purpose: #STANDARD,
      type: #IDENTIFICATION_REFERENCE,
      label: 'General Information',
      position: 10
    }
  ]

  @UI.lineItem:       [{ position: 10, label: 'Request ID' }]
  @UI.identification: [{ position: 10, label: 'Request ID' }]
  RequestID;

  @UI.lineItem:       [{ position: 20, label: 'Request Date' }]
  @UI.identification: [{ position: 20, label: 'Request Date' }]
  @UI.selectionField: [{ position: 10 }]
  RequestDate;

  @UI.lineItem:       [{ position: 30, label: 'Requester' }]
  @UI.identification: [{ position: 30, label: 'Requester' }]
  @UI.selectionField: [{ position: 20 }]
  Requester;

  @UI.lineItem:       [{ position: 40, label: 'Item Text' }]
  @UI.identification: [{ position: 40, label: 'Item Text' }]
  @UI.selectionField: [{ position: 30 }]
  ItemText;

  @UI.lineItem:       [{ position: 50, label: 'Quantity' }]
  @UI.identification: [{ position: 50, label: 'Quantity' }]
  Quantity;

  @UI.lineItem:       [{ position: 60, label: 'Unit' }]
  @UI.identification: [{ position: 60, label: 'Unit' }]
  UnitCode;

  @UI.lineItem:       [{ position: 70, label: 'Cost Center' }]
  @UI.identification: [{ position: 70, label: 'Cost Center' }]
  @UI.selectionField: [{ position: 40 }]
  CostCenter;

  @UI.lineItem:       [{ position: 80, label: 'Status' }]
  @UI.identification: [{ position: 80, label: 'Status' }]
  @UI.selectionField: [{ position: 50 }]
  Status;
}
