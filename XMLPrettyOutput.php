<?php
	class XMLPrettyOutput
		{
		private $xml,$doc,$multiplier = 2;

		public function __construct (SimpleXMLElement $xml)
			{
			$this->xml = $xml;
			$this->doc = new DOMDocument('1.0', 'UTF-8');
			}

		public function setMultiplier(int $multiplier) : self
			{
			$this->multiplier = $multiplier;
			return $this;
			}

		private function addNode(DOMElement $node, string $nodeName) : DOMElement
			{
			$newNode = $this->doc->createElement($nodeName);
			$node->appendChild($newNode);
			return $newNode;
			}

		public function processing() : string
			{
			$mainNode = $this->doc->createElement('Node');
			$this->doc->appendChild($mainNode);
			$this->node($mainNode,$this->xml);
			$xsltFilePath = __DIR__.'/XMLPrettyOutput.xsl';
			if(!file_exists($xsltFilePath))
				{
				throw new Exception('XSLT file not found in: '.$xsltFilePath);
				}
			$mainXSLT = new DOMDocument('1.0', 'utf-8');
			$mainXSLT->load($xsltFilePath);
			$XSLTProcessor = new XSLTProcessor;
			$XSLTProcessor->importStyleSheet($mainXSLT);
			return $XSLTProcessor->transformToXML($this->doc);
			}

		private function marginLeft(int $level) : string
			{
			return $level * $this->multiplier;
			}

		private function node(DOMElement $docNode, SimpleXMLElement $node, int $level = 0)
			{
			foreach ($node->children() as $child)
				{
				$childDocNode = $this->addNode($docNode,'Node');
				$this->node($childDocNode,$child, $level + 1);
				}
			foreach ($node->attributes() as $attr=>$val)
				{
				$attrNode = $this->addNode($docNode,'Attr');
				$attrNode->setAttribute('name',$attr);
				$attrNode->setAttribute('value',$val);
				}
			$nodeName = $node->getName();
			$docNode->setAttribute('marginLeft',$this->marginLeft($level));
			$docNode->setAttribute('name',$nodeName);
			$docNode->setAttribute('value',(string)$node);
			}
		}