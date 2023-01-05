
//// Automatically Generated by generate-swiftbasicformat
//// Do Not Edit Directly!
//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2022 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import SwiftSyntax

open class BasicFormat: SyntaxRewriter {
  public var indentationLevel: Int = 0
  
  open var indentation: TriviaPiece { 
    .spaces(indentationLevel * 4) 
  }
  
  public var indentedNewline: Trivia { 
    Trivia(pieces: [.newlines(1), indentation]) 
  }
  
  private var lastRewrittenToken: TokenSyntax?
  
  private var putNextTokenOnNewLine: Bool = false
  
  open override func visitPre(_ node: Syntax) {
    if let keyPath = getKeyPath(node), shouldIndent(keyPath) {
      indentationLevel += 1
    }
    if let parent = node.parent, childrenSeparatedByNewline(parent) {
      putNextTokenOnNewLine = true
    }
  }
  
  open override func visitPost(_ node: Syntax) {
    if let keyPath = getKeyPath(node), shouldIndent(keyPath) {
      indentationLevel -= 1
    }
  }
  
  open override func visit(_ node: TokenSyntax) -> TokenSyntax {
    var leadingTrivia = node.leadingTrivia
    var trailingTrivia = node.trailingTrivia
    if requiresLeadingSpace(node) && leadingTrivia.isEmpty && lastRewrittenToken?.trailingTrivia.isEmpty != false {
      leadingTrivia += .space
    }
    if requiresTrailingSpace(node) && trailingTrivia.isEmpty {
      trailingTrivia += .space
    }
    if let keyPath = getKeyPath(Syntax(node)), requiresLeadingNewline(keyPath), !(leadingTrivia.first?.isNewline ?? false) {
      leadingTrivia = .newline + leadingTrivia
    }
    leadingTrivia = leadingTrivia.indented(indentation: indentation)
    trailingTrivia = trailingTrivia.indented(indentation: indentation)
    let rewritten = TokenSyntax(
      node.tokenKind, 
      leadingTrivia: leadingTrivia, 
      trailingTrivia: trailingTrivia, 
      presence: node.presence
    )
    lastRewrittenToken = rewritten
    putNextTokenOnNewLine = false
    return rewritten
  }
  
  open func shouldIndent(_ keyPath: AnyKeyPath) -> Bool {
    switch keyPath {
    case \ArrayExprSyntax.elements: 
      return true
    case \ClosureExprSyntax.statements: 
      return true
    case \CodeBlockSyntax.statements: 
      return true
    case \DictionaryElementSyntax.valueExpression: 
      return true
    case \DictionaryExprSyntax.content: 
      return true
    case \FunctionCallExprSyntax.argumentList: 
      return true
    case \FunctionTypeSyntax.arguments: 
      return true
    case \MemberDeclBlockSyntax.members: 
      return true
    case \ParameterClauseSyntax.parameterList: 
      return true
    case \SwitchCaseSyntax.statements: 
      return true
    case \TupleExprSyntax.elementList: 
      return true
    case \TupleTypeSyntax.elements: 
      return true
    default: 
      return false
    }
  }
  
  open func requiresLeadingNewline(_ keyPath: AnyKeyPath) -> Bool {
    switch keyPath {
    case \ClosureExprSyntax.rightBrace: 
      return true
    case \CodeBlockSyntax.rightBrace: 
      return true
    case \MemberDeclBlockSyntax.rightBrace: 
      return true
    case \SwitchStmtSyntax.rightBrace: 
      return true
    default: 
      return putNextTokenOnNewLine
    }
  }
  
  open func childrenSeparatedByNewline(_ node: Syntax) -> Bool {
    switch node.as(SyntaxEnum.self) {
    case .codeBlockItemList: 
      return true
    case .memberDeclList: 
      return true
    case .switchCaseList: 
      return true
    default: 
      return false
    }
  }
  
  open func requiresLeadingSpace(_ token: TokenSyntax) -> Bool {
    switch (token.previousToken(viewMode: .sourceAccurate)?.tokenKind, token.tokenKind) {
    case (.postfixQuestionMark, .rightAngle): 
      return false
    case (.leftParen, .spacedBinaryOperator("*")): 
      return false
    default: 
      break 
    }
    switch token.tokenKind {
    case .inKeyword: 
      return true
    case .whereKeyword: 
      return true
    case .catchKeyword: 
      return true
    case .leftBrace: 
      return true
    case .equal: 
      return true
    case .arrow: 
      return true
    case .spacedBinaryOperator: 
      return true
    default: 
      return false
    }
  }
  
  open func requiresTrailingSpace(_ token: TokenSyntax) -> Bool {
    // Format `[:]` as-is.
    if token.tokenKind == .colon && token.parent?.kind == .dictionaryExpr {
      return false
    }
    switch (token.tokenKind, token.nextToken(viewMode: .sourceAccurate)?.tokenKind) {
    case (.asKeyword, .exclamationMark), 
     (.asKeyword, .postfixQuestionMark), 
     (.exclamationMark, .leftParen), 
     (.exclamationMark, .period), 
     (.initKeyword, .leftParen), 
     (.initKeyword, .postfixQuestionMark), 
     (.postfixQuestionMark, .leftParen), 
     (.postfixQuestionMark, .rightAngle), 
     (.postfixQuestionMark, .rightParen), 
     (.tryKeyword, .exclamationMark), 
     (.tryKeyword, .postfixQuestionMark): 
      return false
    case (.spacedBinaryOperator("*"), .comma): 
      return false
    default: 
      break 
    }
    switch token.tokenKind {
    case .associatedtypeKeyword: 
      return true
    case .classKeyword: 
      return true
    case .deinitKeyword: 
      return true
    case .enumKeyword: 
      return true
    case .extensionKeyword: 
      return true
    case .funcKeyword: 
      return true
    case .importKeyword: 
      return true
    case .initKeyword: 
      return true
    case .inoutKeyword: 
      return true
    case .letKeyword: 
      return true
    case .operatorKeyword: 
      return true
    case .precedencegroupKeyword: 
      return true
    case .protocolKeyword: 
      return true
    case .structKeyword: 
      return true
    case .subscriptKeyword: 
      return true
    case .typealiasKeyword: 
      return true
    case .varKeyword: 
      return true
    case .fileprivateKeyword: 
      return true
    case .internalKeyword: 
      return true
    case .privateKeyword: 
      return true
    case .publicKeyword: 
      return true
    case .staticKeyword: 
      return true
    case .deferKeyword: 
      return true
    case .ifKeyword: 
      return true
    case .guardKeyword: 
      return true
    case .repeatKeyword: 
      return true
    case .elseKeyword: 
      return true
    case .forKeyword: 
      return true
    case .inKeyword: 
      return true
    case .whileKeyword: 
      return true
    case .returnKeyword: 
      return true
    case .breakKeyword: 
      return true
    case .continueKeyword: 
      return true
    case .fallthroughKeyword: 
      return true
    case .switchKeyword: 
      return true
    case .caseKeyword: 
      return true
    case .whereKeyword: 
      return true
    case .throwKeyword: 
      return true
    case .asKeyword: 
      return true
    case .anyKeyword: 
      return true
    case .isKeyword: 
      return true
    case .rethrowsKeyword: 
      return true
    case .tryKeyword: 
      return true
    case .throwsKeyword: 
      return true
    case .wildcardKeyword: 
      return true
    case .comma: 
      return true
    case .colon: 
      return true
    case .equal: 
      return true
    case .arrow: 
      return true
    case .exclamationMark: 
      return true
    case .postfixQuestionMark: 
      return true
    case .poundKeyPathKeyword: 
      return true
    case .poundLineKeyword: 
      return true
    case .poundSelectorKeyword: 
      return true
    case .poundFileKeyword: 
      return true
    case .poundFileIDKeyword: 
      return true
    case .poundFilePathKeyword: 
      return true
    case .poundColumnKeyword: 
      return true
    case .poundFunctionKeyword: 
      return true
    case .poundDsohandleKeyword: 
      return true
    case .poundAssertKeyword: 
      return true
    case .poundSourceLocationKeyword: 
      return true
    case .poundWarningKeyword: 
      return true
    case .poundErrorKeyword: 
      return true
    case .poundIfKeyword: 
      return true
    case .poundElseKeyword: 
      return true
    case .poundElseifKeyword: 
      return true
    case .poundEndifKeyword: 
      return true
    case .poundAvailableKeyword: 
      return true
    case .poundUnavailableKeyword: 
      return true
    case .poundFileLiteralKeyword: 
      return true
    case .poundImageLiteralKeyword: 
      return true
    case .poundColorLiteralKeyword: 
      return true
    case .poundHasSymbolKeyword: 
      return true
    case .spacedBinaryOperator: 
      return true
    case .contextualKeyword("async"): 
      return true
    default: 
      return false
    }
  }
  
  private func getKeyPath(_ node: Syntax) -> AnyKeyPath? {
    guard let parent = node.parent else {
      return nil
    }
    guard case .layout(let childrenKeyPaths) = parent.kind.syntaxNodeType.structure else {
      return nil
    }
    return childrenKeyPaths[node.indexInParent]
  }
}
