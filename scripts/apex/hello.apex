// Account newAccount = new Account(Name = 'Sample Account', Territory__c = 'United States');
// insert newAccount;

// Task newTask = new Task(
//     Subject = 'Sample Task',
//     WhatId = newAccount.Id,
//     Status = 'Not Started',
//     Priority = 'Normal'
// );
// insert newTask;

// Contact newContact = new Contact(
//     FirstName = 'John',
//     LastName = 'Doe',
//     AccountId = newAccount.Id
// );
// insert newContact;

Task t = [SELECT Id, Who.FirstName FROM Task LIMIT 1];
Contact c = [SELECT Id, FirstName FROM Contact LIMIT 1];
t.WhoId = c.Id;
t.put('Who', c);

System.debug(JSON.serialize(t));
