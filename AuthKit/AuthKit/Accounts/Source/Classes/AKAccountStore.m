#import "AKAccountStore.h"

#import "AKAccount_Protected.h"

// TODO(rcacheaux): Enforce unique username for each account of type n.
@interface AKAccountStore ()
@property(nonatomic, strong) NSMutableDictionary *accounts;
@end

@implementation AKAccountStore

- (id)init {
  self = [super init];
  if (self) {
    _accounts = [NSMutableDictionary dictionary];
  }
  return self;
}

- (AKAccount *)newAccount {
  // TODO(rcacheaux): Cache identifiers for new unsaved accounts to make sure
  // the save method only saves accounts created from this class.
  AKAccount *newAccount = [AKAccount accountWithIdentifier:[[NSUUID UUID] UUIDString]];
  return newAccount;
}

- (AKAccount *)accountWithType:(NSString *)type username:(NSString *)username {
  for (NSString *identifier in self.accounts) {
    AKAccount *account = self.accounts[identifier];
    if ([account.username isEqualToString:username]) {
      return account;
    }
  }
  return nil;
}

- (AKAccount *)accountWithIdentifier:(NSString *)identifier {
  return self.accounts[identifier];
}

- (void)saveAccount:(AKAccount *)account
    withCompletionHandler:(void (^)())completionHandler {
  self.accounts[account.identifier] = account;
  completionHandler ? completionHandler() : NULL;
}

@end