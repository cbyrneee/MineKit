//
//  MineKitBuffer.swift
//  
//
//  Created by Conor on 09/06/2021.
//

import Foundation
import NIO

public struct WrappedBuffer {
    public var buffer: ByteBuffer
    
    public init(with buffer: ByteBuffer) {
        self.buffer = buffer
    }
    
    // MARK: - Writing
    
    public mutating func writeByte(_ byte: Int) {
        self.writeByte(UInt8(byte))
    }
    
    public mutating func writeByte(_ byte: UInt8) {
        self.writeBytes([byte])
    }
    
    public mutating func writeBytes(_ bytes: [UInt8]) {
        self.buffer.writeBytes(bytes)
    }
    
    public mutating func writeSignedByte(_ byte: Int8) {
        self.buffer.writeInteger(byte, endianness: .big)
    }
    
    public mutating func writeShort(_ short: Int) {
        self.writeSignedShort(Int16(short))
    }
    
    public mutating func writeSignedShort(_ short: Int16) {
        self.buffer.writeInteger(short, endianness: .big)
    }
    
    public mutating func writeInt(_ int: Int) {
        self.buffer.writeInteger(int, endianness: .big)
    }
    
    public mutating func writeLong(_ long: Int64) {
        self.buffer.writeInteger(long, endianness: .big)
    }
    
    public mutating func writeFloat(_ float: Float32) {
        self.buffer.writeInteger(float.bitPattern, endianness: .big)
    }
    
    public mutating func writeDouble(_ double: Float64) {
        self.buffer.writeInteger(double.bitPattern, endianness: .big)
    }
    
    public mutating func writeVarInt(_ int: Int) {
        var value = int
        
        repeat {
            var temp = value & 0b01111111
            value = value >> 7
            
            if (value != 0) {
                temp = temp | 0b10000000
            }
            
            self.writeByte(temp)
        } while (value != 0)
    }
    
    public mutating func writeVarLong(_ long: Int64) {
        var value = long
        
        repeat {
            var temp = value & 0b01111111
            value = value >> 7
            
            if (value != 0) {
                temp = temp | 0b10000000
            }
            
            self.writeLong(temp)
        } while (value != 0)
    }
    
    public mutating func writeBoolean(_ boolean: Bool) {
        self.writeByte(boolean ? 0x01 : 0x00)
    }
    
    public mutating func writeString(_ string: String) {
        let bytes = string.bytes
        
        writeVarInt(bytes.count)
        writeBytes(bytes)
    }
    
    // MARK: - Reading
    
    public mutating func readByte() -> UInt8? {
        return self.buffer.readInteger(endianness: .big, as: UInt8.self)
    }
    
    public mutating func readBytes(length: Int) -> [UInt8]? {
        return self.buffer.readBytes(length: length)
    }
    
    public mutating func readBytesPrefixedWithLength() throws -> [UInt8]? {
        let length = try self.readVarInt()
        return self.readBytes(length: length)
    }
    
    public mutating func readSignedByte() -> Int8? {
        return self.buffer.readInteger(endianness: .big, as: Int8.self)
    }
    
    public mutating func readSignedShort() -> Int16? {
        return self.buffer.readInteger(endianness: .big, as: Int16.self)
    }
    
    public mutating func readShort() -> UInt16? {
        return self.buffer.readInteger(endianness: .big, as: UInt16.self)
    }
    
    public mutating func readInt() -> Int? {
        return self.buffer.readInteger(endianness: .big, as: Int.self)
    }
    
    public mutating func readLong() -> Int64? {
        return self.buffer.readInteger(endianness: .big, as: Int64.self)
    }
    
    public mutating func readFloat() -> Float32? {
        let pattern = UInt32(bigEndian: self.buffer.readInteger(endianness: .big, as: UInt32.self)!)
        return Float32(bitPattern: pattern)
    }
    
    public mutating func readDouble() -> Float64? {
        let pattern = UInt64(bigEndian: self.buffer.readInteger(endianness: .big, as: UInt64.self)!)
        return Float64(bitPattern: pattern)
    }
    
    public mutating func readVarInt() throws -> Int {
        var numRead = 0
        var result = 0
        var read: Int = 0
        
        repeat {
            guard let byte = readByte() else {
                throw WrappedBufferError.read("Failed to read byte from ByteBuffer when parsing VarInt!")
            }
            
            read = Int(byte)
            let value = read & 0b01111111
            
            result = result | (value << (7 * numRead))
            numRead += 1
            if(numRead > 5) {
                throw WrappedBufferError.read("VarInt is too large!")
            }
        } while((read & 0b10000000) != 0)
        
        return result
    }
    
    public mutating func readVarLong() throws -> Int64 {
        var numRead = 0
        var result: Int64 = 0
        var read: Int = 0
        
        repeat {
            guard let byte = readByte() else {
                throw WrappedBufferError.read("Failed to read byte from ByteBuffer when parsing VarLong!")
            }
            
            read = Int(byte)
            let value = read & 0b01111111
            result = result | Int64((value << (7 * numRead)))
            
            numRead += 1
            if(numRead > 10) {
                throw WrappedBufferError.read("VarLong is too large!")
            }
        } while((read & 0b10000000) != 0)
        
        return result
    }
    
    public mutating func readBoolean() -> Bool? {
        guard let byte = readByte() else {
            return nil
        }
        
        return byte == 0x01
    }
    
    public mutating func readString() throws -> String? {
        let length = try self.readVarInt()
        return self.buffer.readString(length: length)
    }
}
